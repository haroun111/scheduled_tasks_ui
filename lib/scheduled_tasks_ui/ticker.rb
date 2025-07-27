
module ScheduledTasksUi
  class Ticker
    def initialize(throttle_duration, &persist)
      @throttle_duration = throttle_duration
      @persist = persist
      @last_persisted = Time.now
      @ticks_recorded = 0
    end

    def tick
      @ticks_recorded += 1
      persist if persist?
    end

    def persist
      return if @ticks_recorded == 0

      now = Time.now
      duration = now - @last_persisted
      @last_persisted = now
      @persist.call(@ticks_recorded, duration)
      @ticks_recorded = 0
    end

    private

    def persist?
      Time.now - @last_persisted >= @throttle_duration
    end
  end
end