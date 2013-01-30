require 'rspec'
require 'webmock'
require 'chordate-ruby'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true

  config.order = 'random'

  config.before :all do
    WebMock.disable_net_connect!
  end

  config.before :each do
    Chordate::HTTP.stub(:post)
  end
end

module Rails
  def self.root
    `pwd`.chomp
  end

  def self.env
    'the-environment'
  end
end

Chordate.configure do |config|
  config.token = '123:abcdef'
end

def make_exception(type = RuntimeError, message = 'BOOM!')
  raise type.new message
rescue => e
  e
end
