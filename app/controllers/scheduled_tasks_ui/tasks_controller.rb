module ScheduledTasksUi
  class TasksController < ApplicationController
    before_action :set_refresh, only: [:index]

    def index
      @available_tasks = ScheduledTasksUi::TaskDataIndex.available_tasks.group_by(&:category)
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
