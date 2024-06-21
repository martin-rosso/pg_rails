class Evento
  include ActiveModel::API
  include ActionText::Attribute
  extend Enumerize

  attr_accessor :tooltip, :target, :message, :type, :record_type, :record_id

  validates :target, :type, :message, presence: true

  enumerize :target, in: { todos: 0, devs: 1 }
end
