# frozen_string_literal: true

class CreateExamWindows < ActiveRecord::Migration[7.1]
  def change
    create_table :exam_windows do |t|
      t.date :start_time, null: false
      t.date :end_time, null: false
      t.references :exam, null: false, foreign_key: true

      t.timestamps
    end
  end
end
