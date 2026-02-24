class Transactions::ProcessTransaction
  def self.call!(params:, current_user:, request:)
    # Idempotency Key is used to prevent duplicate transactions. If a transaction with the same idempotency key is found, it is returned
    idempotency_key = request.headers["HTTP_IDEMPOTENCY_KEY"]
    raise StandardError, "Missing Idempotency-Key" if idempotency_key.blank?

    existing = Transaction.find_by(
      idempotency_key: idempotency_key,
      account_id: params[:account_id]
    )
    return existing if existing.present?

    ActiveRecord::Base.transaction do
      account = Account.lock.find(params[:account_id])

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