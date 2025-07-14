module ScheduledTasksUiHelper
  def status_class(status)
    case status
    when "pending", "enqueued", "running", "paused"
      "is-warning"
    when "succeeded"
      "is-success"
    when "failed"
      "is-danger"
    when "cancelled"
      "is-light"
    else
      "is-info"
    end
  end
end
