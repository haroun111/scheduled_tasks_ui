module ScheduledTasksUi
  class RunsController < ApplicationController
    before_action :set_run, only: [:pause, :cancel, :resume]

    def create
      run = Runner.run(
        name: params.fetch(:task_id),
        arguments: params.fetch(:task, {}).permit!.to_h,
        metadata: instance_exec(&ScheduledTasksUi.metadata || -> {})
      )
      redirect_to run_path(run)
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = e.message
      @task = ScheduledTasksUi::Tasks.const_get(params[:task_id])
      render "scheduled_tasks_ui/tasks/show"
    rescue Runner::EnqueuingError => e
      redirect_to run_path(run), alert: e.message
    end

    def pause
      Runner.pause(@run)
      redirect_to run_path(@run)
    end

    def cancel
      Runner.cancel(@run)
      redirect_to run_path(@run)
    end

    def resume
      Runner.resume(@run)
      redirect_to run_path(@run)
    rescue Runner::EnqueuingError => e
      redirect_to run_path(@run), alert: e.message
    end

    private

    def set_run
      @run = Run.find(params[:id])
    end
  end
end
