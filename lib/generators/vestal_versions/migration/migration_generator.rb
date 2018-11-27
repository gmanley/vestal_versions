require 'generators/vestal_versions'
require 'rails/generators/active_record'

module VestalVersions
  module Generators
    class MigrationGenerator < ActiveRecord::Generators::Base
      extend Base

      argument :name, :type => :string, :default => 'create_vestal_versions'

      def generate_files
        migration_template 'migration.rb', "db/migrate/#{name}.rb"
        template 'initializer.rb', 'config/initializers/vestal_versions.rb'
      end


      def migration_class
        if ActiveRecord::VERSION::MAJOR >= 5
          version = Float("#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}")
          "ActiveRecord::Migration[#{version}]"
        else
          "ActiveRecord::Migration"
        end
      end
    end
  end
end

