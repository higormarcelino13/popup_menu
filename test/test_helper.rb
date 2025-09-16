ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "mongoid"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    setup do
      # Garante que o Mongoid está conectado ao ambiente de teste
      Mongoid.load!(File.expand_path("../config/mongoid.yml", __dir__), :test)
      # Limpa todas as coleções entre os testes
      Mongoid.default_client.database.collections.each do |collection|
        next if collection.name.start_with?("system.")
        collection.delete_many
      end
    end
  end
end
