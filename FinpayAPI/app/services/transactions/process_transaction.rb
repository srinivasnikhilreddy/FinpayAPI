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
        raise StandardError, "Insufficient funds" if account.balance < transaction.amount
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

=begin

- since above, row-level locking is a Pessimistic locking for financial operations to guarantee balance consistency, 
- but optimistic locking can be introduced for non-financial updates to improve concurrency performance.

# Optimistic locking:
- Uses a lock_version column
- Fails if someone else updated the row
- Raises ActiveRecord::StaleObjectError

=end