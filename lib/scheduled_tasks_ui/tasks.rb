module ScheduledTasksUi
  class Task
    def self.run
      raise NotImplementedError, "Override `.run` in your subclass"
    end

    def self.name
      to_s
    end

    def self.description
      "No description provided"
    end
  end
end
