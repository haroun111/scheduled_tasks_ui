module ScheduledTasksUi
  class Engine < ::Rails::Engine
    isolate_namespace ScheduledTasksUi

    initializer 'scheduled_tasks_ui.load_tasks' do
      # Permet aux apps d'ajouter leurs propres tâches dans app/tasks/scheduled_tasks_ui/tasks
      tasks_path = Rails.root.join('app', 'tasks', 'scheduled_tasks_ui', 'tasks')
      $LOAD_PATH.unshift(tasks_path) if Dir.exist?(tasks_path)
    end
  end
end
