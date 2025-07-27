module ScheduledTasksUi
  class TaskDataShow

    def initialize(name, runs_cursor: nil, arguments: nil)
      @name = name
      @arguments = arguments
      @runs_page = RunsPage.new(completed_runs, runs_cursor)
    end

    class << self
      def prepare(name, runs_cursor: nil, arguments: nil)
        new(name, runs_cursor:, arguments:)
          .load_active_runs
          .ensure_task_exists
      end
    end

    attr_reader :name
    alias_method :to_s, :name

    attr_reader :runs_page

    def code
      return if deleted?

      task = Task.named(name)
      file = if Object.respond_to?(:const_source_location)
        Object.const_source_location(task.name).first
      else
        task.instance_method(:process).source_location.first
      end
      File.read(file)
    end

    def refresh?
      active_runs.any?
    end

    def active_runs
      @active_runs ||= runs.active
    end

    def completed_runs
      @completed_runs ||= runs.completed
    end

    def deleted?
      Task.named(name)
      false
    rescue Task::NotFoundError
      true
    end

    def csv_task?
      !deleted? && Task.named(name).has_csv_content?
    end

    def parameter_names
      if deleted?
        []
      else
        Task.named(name).attribute_names
      end
    end

    def new
      return if deleted?

      task = ScheduledTasksUi::Task.named(name).new
      begin
        task.assign_attributes(@arguments) if @arguments
      rescue ActiveModel::UnknownAttributeError
        # nothing to do
      end
      task
    end

    def load_active_runs
      active_runs.load
      self
    end

    def ensure_task_exists
      if active_runs.none? && runs_page.records.none?
        Task.named(name)
      end
      self
    end

    private

    def runs
      Run.where(task_name: name).with_attached_csv.order(created_at: :desc)
    end
  end
end

