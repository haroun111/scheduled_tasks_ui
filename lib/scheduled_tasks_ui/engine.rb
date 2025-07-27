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
    # Add this initializer to make the SCSS available to the main app
    initializer 'scheduled_tasks_ui.assets.precompile' do |app|
      app.config.assets.precompile += %w[scheduled_tasks_ui/tasks_form.scss]
    end

    # Add the stylesheets path to asset paths
    initializer 'scheduled_tasks_ui.assets' do |app|
      app.config.assets.paths << root.join('app', 'assets', 'stylesheets')
    end
  end
end
