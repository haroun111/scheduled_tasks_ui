module ScheduledTasksUi
  class TaskDataIndex
    class << self
      def available_tasks
        tasks = []

        task_names = Task.load_all.map(&:name)

        active_runs = Run.with_attached_csv.active.where(task_name: task_names)
        active_runs.each do |run|
          tasks << TaskDataIndex.new(run.task_name, run)
          task_names.delete(run.task_name)
        end

        completed_runs = Run.completed.where(task_name: task_names)
        last_runs = Run.with_attached_csv
          .where(created_at: completed_runs.select("MAX(created_at) as created_at").group(:task_name))
        task_names.map do |task_name|
          last_run = last_runs.find { |run| run.task_name == task_name }
          tasks << TaskDataIndex.new(task_name, last_run)
        end

        tasks.sort_by! { |task| [task.name, task.status] }
      end
    end

    def initialize(name, related_run = nil)
      @name = name
      @related_run = related_run
    end

    def description
      name.safe_constantize.try(:description) || ""
    end
    
    attr_reader :name
    attr_reader :related_run

    alias_method :to_s, :name

    def status
      related_run&.status || "new"
    end

    def category
      if related_run.present? && related_run.active?
        :active
      elsif related_run.nil?
        :new
      else
        :completed
      end
    end
  end
end