# frozen_string_literal: true

class CreateColleges < ActiveRecord::Migration[7.1]
  def change
    create_table :colleges do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
