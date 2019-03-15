if ENV['CODECLIMATE_REPO_TOKEN']
  require 'simplecov'
  SimpleCov.start
end

require 'guided_interactor'

Dir[File.expand_path('support/*.rb', __dir__)].each { |f| require f }
