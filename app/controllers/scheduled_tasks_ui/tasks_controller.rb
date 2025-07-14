module ScheduledTasksUi
  class TasksController < ApplicationController
    before_action :set_refresh, only: [:index]

    def index
      tasks = ScheduledTasksUi::Task.constants.map do |const|
        task_class = ScheduledTasksUi::Task.const_get(const)
        OpenStruct.new(
          name: task_class.name,
          category: task_class.respond_to?(:category) ? task_class.category : "Default",
          description: task_class.respond_to?(:description) ? task_class.description : "",
          status: :new
        )
      end
      @available_tasks = { new: tasks, active: [], completed: [] }
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
