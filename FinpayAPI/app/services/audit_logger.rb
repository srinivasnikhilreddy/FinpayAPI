# app/services/audit_logger.rb

class AuditLogger
  # Create a new audit log
  def self.log!(user:, action:, resource: nil, request: nil, metadata: {})
    AuditLog.create!(
      user_id: user&.id,
      action: action,
      resource_type: resolve_resource_type(resource, metadata),
      resource_id: resource&.id,
      metadata: build_metadata(resource, metadata),
      ip_address: request&.remote_ip,
      request_id: request&.request_id
    )
  rescue => e
    Rails.logger.error("[AUDIT_LOG_FAILURE] #{e.class} - #{e.message}")
  end

  private

  def self.resolve_resource_type(resource, metadata)
    return resource.class.name if resource.present?
    return metadata[:resource_type] if metadata[:resource_type].present?

    "System"
  end

  def self.build_metadata(resource, metadata)
    base = resource.present? ? resource.attributes : {}
    base.merge(metadata)
  end
end