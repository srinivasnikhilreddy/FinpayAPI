module SoftDeletable
  # soft deletes is used for financial entities to preserve auditability and prevent destructive loss of financial records
  # Hard delete: DELETE FROM accounts WHERE id=1;
  # Soft delete: UPDATE accounts SET deleted_at = NOW() WHERE id=1;
  
  extend ActiveSupport::Concern
  # Class methods:
  included do
    # Automatically exclude soft-deleted records
    default_scope { where(deleted_at: nil) } # Account.all => SELECT * FROM accounts WHERE deleted_at IS NULL;

    # Include soft-deleted records
    scope :with_deleted, -> { unscope(where: :deleted_at) } # Remove any filtering on deleted_at column, means it returns all the records including deleted records
    
    # Only soft-deleted records
    scope :only_deleted, -> { unscope(where: :deleted_at).where.not(deleted_at: nil) } # Show only records that were soft deleted, means it returns only deleted records
  end

  # Instance methods:
  # Mark record as deleted
  def soft_delete!
    update!(deleted_at: Time.current) 
  end

  # Restore soft-deleted record
  def restore!
    update!(deleted_at: nil) # marks record as active again by setting deleted_at to nil
  end

  # Check if record is soft-deleted
  def deleted?
    deleted_at.present?
  end
end
