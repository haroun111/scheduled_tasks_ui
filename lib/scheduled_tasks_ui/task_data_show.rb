module ScheduledTasksUi
  class TaskDataShow
    def self.prepare(task_name, runs_cursor: nil, arguments: {})
      task_class = ScheduledTasksUi::Tasks.const_get(task_name)

      unless task_class.is_a?(Class)
        raise ArgumentError, "#{task_name} is not a valid task class"
      end

      runs = ScheduledTasksUi::Run
               .where(task_name: task_name)
               .order(created_at: :desc)
               .limit(10)

      OpenStruct.new(task: task_class, runs: runs, arguments: arguments)
    end
  end
end
