require "#{__dir__}/../../pg_layout/lib/pg_layout"
require "#{__dir__}/../../pg_engine/lib/pg_engine"
require "#{__dir__}/../../pg_associable/lib/pg_associable"
require "#{__dir__}/../../pg_scaffold/lib/pg_scaffold" if Rails.env.local?

module PgRails
end
