# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:dashboards) do
      primary_key :id

      String :name, null: false

      DateTime :created_at
      DateTime :updated_at

      unique [:name]
    end
  end
end