module ScheduledTasksUi
  class TasksController < ApplicationController
    before_action :set_refresh, only: [:index]

    # Affiche toutes les tâches disponibles, groupées par catégorie
    def index
      @available_tasks = TaskDataIndex.available_tasks.group_by(&:category)
    end

    # Affiche une tâche spécifique avec les exécutions associées
    def show
      @task = TaskDataShow.prepare(
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
