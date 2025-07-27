module ScheduledTasksUi
  # Strategy for building a Task that has no collection. These Tasks
  # consist of a single iteration.
  #
  # @api private
  class NoCollectionBuilder
    def collection(_task)
      :no_collection
    end

    def count(_task)
      1
    end

    def has_csv_content?
      false
    end

    def no_collection?
      true
    end
  end
end