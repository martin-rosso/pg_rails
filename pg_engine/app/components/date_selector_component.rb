class DateSelectorComponent < ViewComponent::Base
  def initialize(field_id)
    @field_id = field_id

    @types = [
      ['Días hábiles no feriados', 'business_days_excluding_holidays'],
      ['Días hábiles (L a V)', 'business_days'],
      ['Días corridos (L a D)', 'calendar_days'],
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
