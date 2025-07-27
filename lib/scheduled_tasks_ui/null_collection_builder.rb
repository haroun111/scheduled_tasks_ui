
module ScheduledTasksUi
  class NullCollectionBuilder

    def collection(task)
      raise NoMethodError, "#{task.class.name} must implement `collection`."
    end

    def count(task)
      :no_count
    end

    def has_csv_content?
      false
    end

    def no_collection?
      false
    end
  end
end