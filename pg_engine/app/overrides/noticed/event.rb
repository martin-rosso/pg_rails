Noticed::Event.class_eval do
  attr_accessor :tooltip

  has_rich_text :message
end
