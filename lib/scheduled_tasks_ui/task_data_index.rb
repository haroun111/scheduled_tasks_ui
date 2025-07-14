module ScheduledTasksUi
  class TaskDataIndex
    def self.available_tasks
      ScheduledTasksUi::Tasks.constants.map do |const_name|
        task_class = ScheduledTasksUi::Tasks.const_get(const_name)
        OpenStruct.new(
          name: task_class.name,
          category: task_class.respond_to?(:category) ? task_class.category : "Default",
          description: task_class.respond_to?(:description) ? task_class.description : ""
        )
      end
    end
  end
end
