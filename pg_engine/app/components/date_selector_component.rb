class DateSelectorComponent < ViewComponent::Base
  def initialize(field_id)
    @field_id = field_id

    @types = [
      'Días corridos',
      'Días hábiles (L a V)',
      'Días hábiles + feriados',
      'Semanas',
      'Meses'
    ]

    super
  end
end
