require 'active_model'

module ScheduledTasksUi
  class Task
    extend ActiveSupport::DescendantsTracker
    include ActiveSupport::Callbacks
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment
    include ActiveModel::Validations
    include ActiveSupport::Rescuable

    class NotFoundError < NameError; end

    class_attribute :throttle_conditions, default: []

    class_attribute :active_record_enumerator_batch_size

    class_attribute :collection_builder_strategy, default: NullCollectionBuilder.new

    class_attribute :masked_arguments, default: []

    class_attribute :status_reload_frequency, default: 5000

    define_callbacks :start, :complete, :error, :cancel, :pause, :interrupt

    attr_accessor :metadata

    class << self
      def named(name)
        task = name.safe_constantize
        raise NotFoundError.new("Task #{name} not found.", name) unless task
        unless task.is_a?(Class) && task < Task
          raise NotFoundError.new("#{name} is not a Task.", name)
        end

        task
      end
      
      def load_all
        load_constants
        descendants
      end

      def available_tasks
        warn(<<~MSG.squish, category: :deprecated)
          ScheduledTasksUi::Task.available_tasks is deprecated and will be
          removed from scheduled-tasks-ui 0.1.0. Use .load_all instead.
        MSG
        load_all
      end

      def csv_collection(in_batches: nil, **csv_options)
        unless defined?(ActiveStorage)
          raise NotImplementedError, "Active Storage needs to be installed\n" \
            "To resolve this issue run: bin/rails active_storage:install"
        end

        csv_options[:headers] = true unless csv_options.key?(:headers)
        csv_options[:encoding] ||= Encoding.default_external
        self.collection_builder_strategy = if in_batches
          BatchCsvCollectionBuilder.new(in_batches, **csv_options)
        else
          CsvCollectionBuilder.new(**csv_options)
        end
      end

      def no_collection
        self.collection_builder_strategy = ScheduledTasksUi::NoCollectionBuilder.new
      end

      delegate :has_csv_content?, :no_collection?, to: :collection_builder_strategy

      def process(*args)
        new.process(*args)
      end

      def collection
        new.collection
      end

      def count
        new.count
      end

      def throttle_on(backoff: 30.seconds, &condition)
        backoff_as_proc = backoff
        backoff_as_proc = -> { backoff } unless backoff.respond_to?(:call)

        self.throttle_conditions += [{ throttle_on: condition, backoff: backoff_as_proc }]
      end

      def collection_batch_size(size)
        self.active_record_enumerator_batch_size = size
      end

      def mask_attribute(*attributes)
        self.masked_arguments += attributes
      end

      def reload_status_every(frequency)
        self.status_reload_frequency = frequency
      end

      def after_start(*filter_list, &block)
        set_callback(:start, :after, *filter_list, &block)
      end

      def after_complete(*filter_list, &block)
        set_callback(:complete, :after, *filter_list, &block)
      end

      def after_pause(*filter_list, &block)
        set_callback(:pause, :after, *filter_list, &block)
      end

      def after_interrupt(*filter_list, &block)
        set_callback(:interrupt, :after, *filter_list, &block)
      end

      def after_cancel(*filter_list, &block)
        set_callback(:cancel, :after, *filter_list, &block)
      end

      def after_error(*filter_list, &block)
        set_callback(:error, :after, *filter_list, &block)
      end

      def report_on(*exceptions, **report_options)
        rescue_from(*exceptions) do |exception|
          if Rails.gem_version >= Gem::Version.new("7.1")
            Rails.error.report(exception, source: "scheduled_tasks_ui", **report_options)
          else
            Rails.error.report(exception, handled: true, **report_options)
          end
        end
      end

      private

      def load_constants
        namespace = ScheduledTasksUi.tasks_module.safe_constantize
        return unless namespace

        Rails.autoloaders.main.eager_load_namespace(namespace)
      end
    end

    def csv_content
      raise NoMethodError unless has_csv_content?

      @csv_content
    end

    def csv_content=(csv_content)
      raise NoMethodError unless has_csv_content?

      @csv_content = csv_content
    end

    def has_csv_content?
      self.class.has_csv_content?
    end

    def no_collection?
      self.class.no_collection?
    end

    def collection
      self.class.collection_builder_strategy.collection(self)
    end

    def cursor_columns
      nil
    end

    def process(_item)
      raise NoMethodError, "#{self.class.name} must implement `process`."
    end

    def count
      self.class.collection_builder_strategy.count(self)
    end

    def enumerator_builder(cursor:)
      nil
    end
  end
end