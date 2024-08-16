module PgEngine
  class DateJumper
    def initialize(start_date)
      @start_date = start_date
    end

    def business_days(days, direction:, exclude_holidays: false)
      case direction
      when :forward, 'forward'
        business_forward(days, exclude_holidays:)
      when :backward, 'backward'
        business_backward(days, exclude_holidays:)
      else
        raise PgEngine::Error, 'direction not supported'
      end
    end

    def business_forward(days, exclude_holidays: false)
      days.times.inject(@start_date) do |acc, _|
        if exclude_holidays
          find_excluding_holidays(method: :next_business_day, from: acc)
        else
          next_business_day(acc)
        end
      end
    end

    def business_backward(days, exclude_holidays: false)
      days.times.inject(@start_date) do |acc, _|
        if exclude_holidays
          find_excluding_holidays(method: :prev_business_day, from: acc)
        else
          prev_business_day(acc)
        end
      end
    end

    private

    def find_excluding_holidays(method:, from:)
      aux = from
      safe_counter = 0
      loop do
        safe_counter += 1
        aux = send(method, aux)
        if safe_counter > 10
          raise 'las cosas'
        end
        break unless Holidays.on(aux, :ar).any?
      end
      aux
    end

    def next_business_day(date)
      if date.wday.in? [0, 5, 6]
        date.next_occurring(:monday)
      else
        date.advance(days: 1)
      end
    end

    def prev_business_day(date)
      if date.wday.in? [0, 1, 6]
        date.prev_occurring(:friday)
      else
        date.advance(days: -1)
      end
    end
  end
end
