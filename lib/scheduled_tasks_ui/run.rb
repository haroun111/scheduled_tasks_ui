module ScheduledTasksUi
  class Run <  ActiveRecord::Base
    self.table_name = "scheduled_tasks_ui_runs"

    # Enum pour gérer les statuts possibles
    enum :status, [:pending, :enqueued, :running, :paused, :succeeded, :failed, :cancelled]

    # On peut ajouter des scopes pour faciliter la requête par status
    scope :active, -> { where(status: %w[pending enqueued running paused]) }
    scope :completed, -> { where(status: %w[succeeded failed cancelled]) }

    # Pour savoir si la tâche est encore en cours
    def in_progress?
      pending? || enqueued? || running? || paused?
    end
  end
end
