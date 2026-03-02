class ExpenseWorkflowService
  def initialize(expense:, actor:, request:)
    @expense = expense
    @actor   = actor
    @request = request
  end

  def approve!
    transition!(:approve)
  end

  def reject!
    transition!(:reject)
  end

  def reimburse!
    transition!(:mark_reimbursed)
  end

  def archive!
    transition!(:archive)
  end

  private

  attr_reader :expense, :actor, :request

  def transition!(event)
    unless expense.public_send("may_#{event}?", actor)
        raise AASM::InvalidTransition
    end
    
    Expense.transaction do
        expense.public_send("#{event}!", actor)
        log_activity(event)
    end
    expense
  end

  def log_activity(event)
    ActivityLog.create!(
      user: actor,
      expense: expense,
      action: event.to_s,
      metadata: {
        ip: request.remote_ip,
        user_agent: request.user_agent
      }
    )
  end
end