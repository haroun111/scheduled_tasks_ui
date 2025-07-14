module ScheduledTasksUi
  class TaskDataIndex
    def self.available_tasks
      ScheduledTasksUi::Tasks.constants.map do |const_name|
        const = ScheduledTasksUi::Tasks.const_get(const_name)
        next unless const.is_a?(Class)

        OpenStruct.new(
          name: const.name,
          category: const.respond_to?(:category) ? const.category : "Default",
          description: const.respond_to?(:description) ? const.description : ""
        )
      end.compact
    end
  end
end
