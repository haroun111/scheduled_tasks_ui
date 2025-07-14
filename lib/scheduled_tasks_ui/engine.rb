module ScheduledTasksUi
  class Engine < ::Rails::Engine
    isolate_namespace ScheduledTasksUi

    initializer 'scheduled_tasks_ui.load_tasks' do
      tasks_path = Rails.root.join('app', 'tasks', 'scheduled_tasks_ui', 'tasks')
      if Dir.exist?(tasks_path)
        Dir[tasks_path.join('*.rb')].sort.each do |file|
          require file
        end
      end
    end
  end
end
