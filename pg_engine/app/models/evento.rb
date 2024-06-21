class Evento
  include ActiveModel::API
  include ActionText::Attribute
  extend Enumerize

  attr_accessor :tooltip, :target, :message, :type, :record_type, :record_id

  validates :target, :type, :message, presence: true

  # has_rich_text :message, encrypted: false, strict_loading: false

  def self.strict_loading_by_default
    false
  end

  enumerize :target, in: { todos: 0, devs: 1 }
end
