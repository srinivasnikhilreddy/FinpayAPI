class ApprovalWorkflowService
  def initialize(approval:, actor:, request:)
    @approval = approval
    @actor    = actor
    @request  = request
  end

  def approve!
    transition!(:approve)
  end

  def reject!
    transition!(:reject)
  end

  private

  attr_reader :approval, :actor, :request

  def transition!(event)
    unless approval.public_send("may_#{event}?", actor)
        raise AASM::InvalidTransition
    end

    Approval.transaction do
        approval.public_send("#{event}!", actor)
        sync_expense_status!
        log_activity(event)
    end

    approval
  end

  def sync_expense_status!
    expense = approval.expense

    statuses = expense.approvals.active.pluck(:status)

    return if statuses.empty?

    if statuses.include?("rejected")
      expense.reject!(actor) if expense.may_reject?(actor)
    elsif statuses.all?("approved")
      expense.approve!(actor) if expense.may_approve?(actor)
    end
  end

  def log_activity(event)
    ActivityLog.create!(
      user: actor,
      expense: approval.expense,
      action: "approval_#{event}",
      metadata: {
        approval_id: approval.id,
        ip: request.remote_ip
      }
    )
  end
end