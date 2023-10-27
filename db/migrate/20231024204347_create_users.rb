# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number

      t.timestamps
    end
    add_index :users, [:first_name, :last_name, :phone_number]
  end
end
