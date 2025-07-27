class CreateRuns < ActiveRecord::Migration[7.0]
  def change
    create_table(:scheduled_tasks_ui_runs, id: primary_key_type) do |t|
      t.string(:task_name, null: false)
      t.datetime(:started_at)
      t.datetime(:ended_at)
      t.float(:time_running, default: 0.0, null: false)
      t.bigint(:tick_count, default: 0, null: false)
      t.bigint(:tick_total)
      t.string(:job_id)
      t.string(:cursor)
      t.string(:status, default: :enqueued, null: false)
      t.string(:error_class)
      t.string(:error_message)
      t.text(:backtrace)
      t.text(:arguments)
      t.integer(:lock_version, default: 0, null: false)
      t.timestamps
      t.index(
        [:task_name, :status, :created_at],
        name: :index_scheduled_tasks_ui_runs,
        order: { created_at: :desc }
      )
      t.text(:metadata)
    end
  end

  private

  def primary_key_type
    config = Rails.configuration.generators
    setting = config.options[config.orm][:primary_key_type]
    setting || :primary_key
  end
end
