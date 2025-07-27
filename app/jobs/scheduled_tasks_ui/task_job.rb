module ScheduledTasksUi
  # Base class that is inherited by the host application's task classes.
  class TaskJob < ActiveJob::Base
    include TaskJobConcern
  end
end