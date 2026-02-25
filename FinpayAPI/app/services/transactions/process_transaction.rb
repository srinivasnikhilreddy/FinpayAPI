class Transactions::ProcessTransaction
  def self.call!(params:, current_user:, request:)
    # Idempotency Key is used to prevent duplicate transactions. If a transaction with the same idempotency key is found, it is returned
    # To prevent double-spending or duplicate API calls, I have implemented idempotency using a unique idempotency key combined with row-level locking on accounts inside a database transaction.
    idempotency_key = request.headers["HTTP_IDEMPOTENCY_KEY"]
    raise StandardError, I18n.t("transactions.missing_idempotency_key") if idempotency_key.blank?

    account_id = params[:account_id]

    # Idempotency check (outside lock for fast return)
    existing = Transaction.find_by(
      idempotency_key: idempotency_key,
      account_id: account_id
    )
    return existing if existing.present?

    ActiveRecord::Base.transaction do
      # prevents race conditions where two users try to create a transaction with the same idempotency key at the same time
      # Only one transaction per account at a time, Prevent race conditions, Prevent double-spending, Keep idempotency intact
      Account.with_advisory_lock(account_id) do # Advisory Lock (DB-level lock)
        
        # Double-check idempotency inside lock (when B gets lock after A is committed and lock releases, B can create a duplicate transaction with the same idempotency key)
        existing = Transaction.find_by(
          idempotency_key: idempotency_key,
          account_id: account_id
        )
        return existing if existing.present?

        account = Account.find(account_id)

        transaction = create_transaction!(
          params: params,
          idempotency_key: idempotency_key
        )

        apply_balance_update!(account, transaction)

        AuditLogger.log!(
          user: current_user,
          action: "transaction_created",
          resource: transaction,
          request: request
        )

        transaction
      end
    end

  rescue ActiveRecord::RecordNotUnique
    # DB-level protection fallback
    Transaction.find_by!(
      idempotency_key: idempotency_key,
      account_id: account_id
    )
  end

  private

  def self.create_transaction!(params:, idempotency_key:)
    Transaction.create!(
      params.merge(idempotency_key: idempotency_key)
    )
  end

  def self.apply_balance_update!(account, transaction)
    if transaction.credit?
      account.deposit(transaction.amount)
    else
      raise StandardError, I18n.t("transactions.insufficient_funds") if account.balance < transaction.amount
      account.withdraw(transaction.amount)
    end
  end
end

=begin
class Transactions::ProcessTransaction
  def self.call!(params:, current_user:, request:)
    # Idempotency Key is used to prevent duplicate transactions. If a transaction with the same idempotency key is found, it is returned
    # To prevent double-spending or duplicate API calls, I have implemented idempotency using a unique idempotency key combined with row-level locking on accounts inside a database transaction.
    idempotency_key = request.headers["HTTP_IDEMPOTENCY_KEY"]
    raise StandardError, "Missing Idempotency-Key" if idempotency_key.blank?

    existing = Transaction.find_by(
      idempotency_key: idempotency_key,
      account_id: params[:account_id]
    )
    return existing if existing.present?

    ActiveRecord::Base.transaction do
      # prevents race conditions where two users try to create a transaction with the same idempotency key at the same time
      account = Account.lock.find(params[:account_id]) # row-level locking on accounts inside a database transaction

      transaction = Transaction.create!(
        params.merge(idempotency_key: idempotency_key)
      )

      if transaction.transaction_type == "credit"
        account.deposit(transaction.amount)
      else
        raise StandardError, I18n.t("transactions.insufficient_funds") if account.balance < transaction.amount
        account.withdraw(transaction.amount)
      end

      AuditLogger.log!(
        user: current_user,
        action: "transaction_created",
        resource: transaction,
        request: request
      )

      transaction
    end
  end
end
=end

=begin

- since above, row-level locking is a Pessimistic locking for financial operations to guarantee balance consistency, 
- but optimistic locking can be introduced for non-financial updates to improve concurrency performance.

# Optimistic locking:
- Uses a lock_version column
- Fails if someone else updated the row
- Raises ActiveRecord::StaleObjectError

=end