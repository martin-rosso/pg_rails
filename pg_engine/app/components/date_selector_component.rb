class DateSelectorComponent < ViewComponent::Base
  def initialize(field_id)
    @field_id = field_id

    @types = [
      ['Días corridos (L a D)', 'calendar_days'],
      ['Días hábiles (L a V)', 'business_days'],
      ['Días hábiles no feriados', 'business_days_excluding_holidays'],
      ['Semanas', 'weeks'],
      ['Meses', 'months']
    ]

    @directions = [
      ['Hacia adelante', 'forward'],
      ['Hacia atrás', 'backward']
    ]
    super
  end
end
