module ScheduledTasksUi
  class RunsPage
    RUNS_PER_PAGE = 10

    def initialize(runs, cursor)
      @runs = runs
      @cursor = cursor
    end

    attr_reader :cursor

    def records
      @records ||= begin
        runs_after_cursor = if @cursor.present?
          @runs.where("id < ?", @cursor)
        else
          @runs
        end
        limited_runs = runs_after_cursor.limit(RUNS_PER_PAGE + 1).load
        @extra_run = limited_runs.length > RUNS_PER_PAGE ? limited_runs.last : nil
        limited_runs.take(RUNS_PER_PAGE)
      end
    end

    def next_cursor
      records.last.id
    end

    def last?
      records
      @extra_run.nil?
    end
  end
end