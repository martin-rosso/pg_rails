module Users
  class DateJumperController < ApplicationController
    def jump
      start_date = Date.parse(params[:start_date])
      quantity = params[:quantity].to_i

      date =
        case params[:type]
        when 'calendar_days'
          start_date + (multiplier * quantity.days)
        when 'business_days', 'business_days_excluding_holidays'
          resolve_business_days(start_date, quantity)
        when 'week'
          start_date + (multiplier * quantity.weeks)
        when 'month'
          start_date + (multiplier * quantity.months)
        else
          raise PgEngine::Error, 'type no soportado'
        end

      render json: { date: }
    end

    private

    def resolve_business_days(start_date, quantity)
      exclude_holidays = params[:type].include?('excluding_holidays')
      options = { direction: params[:direction], exclude_holidays: }

      PgEngine::DateJumper.new(start_date)
                          .business_days(quantity, **options)
    end

    def multiplier
      if params[:direction] == 'forward'
        1
      else
        -1
      end
    end
  end
end
