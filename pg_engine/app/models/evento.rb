class Evento
  include ActiveModel::API
  include ActionText::Attribute
  extend Enumerize

  attr_accessor :tooltip, :target, :message, :message_text, :type,
                :record_type, :record_id,
                :subject, :user_ids

  validates :target, :type, :message, presence: true

  enumerize :target, in: { todos: 0, devs: 1, user_ids: 2 }

  validates :message_text, :subject, presence: true, if: lambda {
    type == 'EmailUserNotifier'
  }

  validates :user_ids, presence: true, if: lambda {
    target == 'user_ids'
  }

  def record
    return if record_id.blank?

    record_type.constantize.find(record_id)
  end
end
