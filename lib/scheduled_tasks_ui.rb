# frozen_string_literal: true
require "job-iteration"

module ScheduledTasksUi
  class Error < StandardError; end
  mattr_accessor :tasks_module, default: "Scheduled"
  mattr_accessor :job, default: "ScheduledTasksUi::TaskJob"
  mattr_accessor :ticker_delay, default: 1.second
  mattr_accessor :active_storage_service
  mattr_accessor :backtrace_cleaner
  mattr_accessor :parent_controller, default: "ActionController::Base"
  mattr_accessor :metadata, default: nil
  mattr_accessor :stuck_task_duration, default: 5.minutes
  mattr_accessor :status_reload_frequency, default: 30.second
end

require_relative "scheduled_tasks_ui/version"
require_relative "scheduled_tasks_ui/engine"
require_relative 'scheduled_tasks_ui/null_collection_builder'
require_relative 'scheduled_tasks_ui/no_collection_builder'
require_relative "scheduled_tasks_ui/task"
require_relative "scheduled_tasks_ui/task_data_index"
require_relative "scheduled_tasks_ui/task_data_show"
require_relative "scheduled_tasks_ui/application_record" 
require_relative "../app/validators/scheduled_tasks_ui/run_status_validator"
require_relative "../app/jobs/concerns/scheduled_tasks_ui/task_job_concern"
require_relative "../app/jobs/scheduled_tasks_ui/task_job"
require_relative "scheduled_tasks_ui/run"
require_relative "scheduled_tasks_ui/runs_page"
require_relative "scheduled_tasks_ui/runner"
require_relative "scheduled_tasks_ui/progress"
require_relative "scheduled_tasks_ui/ticker"
