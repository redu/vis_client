$:.unshift File.dirname(__FILE__)

require 'bundler/setup'
require 'vis_client'
require 'faraday'
require 'webmock/rspec'
require 'roar'
require 'active_record'
require 'valium'
require 'delayed_job_mongoid'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
require "support/setup_ar_and_schema"
require "support/thing_vis_representer"

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("vis_client_test")
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  Delayed::Worker.delay_jobs = false

  config.before do
    WebMock.disable_net_connect!
  end
end
