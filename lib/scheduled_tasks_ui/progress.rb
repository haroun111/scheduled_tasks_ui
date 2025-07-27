# frozen_string_literal: true

module ScheduledTasksUi
  class Progress
    include ActiveSupport::NumberHelper
    include ActionView::Helpers::TextHelper

    def initialize(run)
      @run = run
    end

    def value
      @run.tick_count if estimatable? || @run.stopped?
    end

    def max
      estimatable? ? @run.tick_total : @run.tick_count
    end
 
    def text
      count = @run.tick_count
      total = @run.tick_total

      if !total?
        "Processed #{number_to_delimited(count)} " \
          "#{"item".pluralize(count)}."
      elsif over_total?
        "Processed #{number_to_delimited(count)} " \
          "#{"item".pluralize(count)} " \
          "(expected #{number_to_delimited(total)})."
      else
        percentage = 100.0 * count / total

        "Processed #{number_to_delimited(count)} out of " \
          "#{number_to_delimited(total)} #{"item".pluralize(total)} " \
          "(#{number_to_percentage(percentage, precision: 0)})."
      end
    end

    private

    def total?
      @run.tick_total.to_i > 0
    end

    def estimatable?
      total? && !over_total?
    end

    def over_total?
      @run.tick_count > @run.tick_total
    end
  end
end