class CreateRuns < ActiveRecord::Migration[7.0]
  def change
    create_table :scheduled_tasks_ui_runs do |t|
      t.string :task_name, null: false
      t.string :status, null: false, default: "pending"
      t.text :arguments
      t.text :metadata
      t.string :csv_file_path
      t.datetime :started_at
      t.datetime :ended_at
      t.timestamps
    end

    add_index :scheduled_tasks_ui_runs, :task_name
    add_index :scheduled_tasks_ui_runs, :status
  end
end
