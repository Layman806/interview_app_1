# frozen_string_literal: true

class CreateExams < ActiveRecord::Migration[7.1]
  def change
    create_table :exams do |t|
      t.string :name, null: false
      t.references :college, null: false, foreign_key: true

      t.timestamps
    end
  end
end
