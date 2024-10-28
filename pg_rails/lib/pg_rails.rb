# Para que la viewpath y localepath de pg_rails tengan precedencia sobre las de kaminari y devise
require 'kaminari'
require 'devise'
require 'devise-i18n'
require 'devise_invitable'

require "#{__dir__}/../../pg_engine/lib/pg_engine"
require "#{__dir__}/../../pg_associable/lib/pg_associable"
require "#{__dir__}/../../pg_scaffold/lib/pg_scaffold" if Rails.env.local?
require "#{__dir__}/../../pg_layout/lib/pg_layout"

module PgRails
end
