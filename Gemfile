source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in pg_rails.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

eval File.read(__dir__ + '/dev_gemfile.rb'), nil, 'dev_gemfile.rb'

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

gem "bootsnap", require: false
gem 'ostruct'

# gem 'bulky', path: '../bulky'
gem 'bulky', git: 'https://github.com/martin-rosso/bulky.git', branch: 'main'
