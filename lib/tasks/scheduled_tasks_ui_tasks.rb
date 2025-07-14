namespace :scheduled_tasks_ui do
  namespace :install do
    desc "Copy migrations from scheduled_tasks_ui to application"
    task migrations: :environment do
      source = File.expand_path("../../../db/migrate/", __FILE__)
      destination = Rails.root.join("db/migrate")
      FileUtils.mkdir_p(destination)
      FileUtils.cp_r(Dir.glob("#{source}/*"), destination)
      puts "Migrations copied!"
    end
  end
end
