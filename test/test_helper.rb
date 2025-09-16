ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "mongoid"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)

    fixtures :all

    setup do
      Mongoid.load!(File.expand_path("../config/mongoid.yml", __dir__), :test)
      Mongoid.default_client.database.collections.each do |collection|
        next if collection.name.start_with?("system.")
        collection.delete_many
      end
    end
  end
end
