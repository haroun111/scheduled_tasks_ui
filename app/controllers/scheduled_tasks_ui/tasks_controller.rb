module ScheduledTasksUi
  class TasksController < ApplicationController
    before_action :set_refresh, only: [:index]

    def index
      @available_tasks = {
                            new: ScheduledTasksUi::TaskDataIndex.available_tasks.select { |t| t.status == :new },
                            active: ScheduledTasksUi::TaskDataIndex.available_tasks.select { |t| t.status == :active },
                            completed: ScheduledTasksUi::TaskDataIndex.available_tasks.select { |t| t.status == :completed },
                            failed: TaskDataIndex.available_tasks.select { |t| t.status == :failed }

                          }
    end

    def show
      @task = ScheduledTasksUi::TaskDataShow.prepare(
        params.fetch(:id),
        runs_cursor: params[:cursor],
        arguments: params.except(:id, :controller, :action).permit!
      )
    end

    private

    def set_refresh
      @refresh = true
    end
  end
end
