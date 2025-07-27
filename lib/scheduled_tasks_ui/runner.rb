
module ScheduledTasksUi
  module Runner
    extend self
    class EnqueuingError < StandardError

      def initialize(run)
        super("The job to perform #{run.task_name} could not be enqueued")
        @run = run
      end

      attr_reader :run
    end

    def run(name:, csv_file: nil, arguments: {}, run_model: Run, metadata: nil)
      run = run_model.new(task_name: name, arguments: arguments, metadata: metadata)
      if csv_file
        run.csv_file.attach(csv_file)
        run.csv_file.filename = filename(name)
      end
      job = instantiate_job(run)
      run.job_id = job.job_id
      yield run if block_given?
      
      run.enqueued!
      run.save!
      ScheduledTasksUi::TaskJob.perform_later(run)
      #enqueue(run, job)
      Task.named(name)
    end

    def resume(run)
      job = instantiate_job(run)
      run.job_id = job.job_id
      run.enqueued!
      enqueue(run, job)
    end

    private

    def enqueue(run, job)
      unless job.enqueue
        raise "The job to perform #{run.task_name} could not be enqueued. " \
          "Enqueuing has been prevented by a callback."
      end
    rescue => error
      run.persist_error(error)
      raise EnqueuingError, run
    end

    def filename(task_name)
      formatted_task_name = task_name.underscore.gsub("/", "_")
      "#{Time.now.utc.strftime("%Y%m%dT%H%M%SZ")}_#{formatted_task_name}.csv"
    end

    def instantiate_job(run)
      ScheduledTasksUi.job.constantize.new(run)
    end
  end
end