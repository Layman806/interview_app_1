# frozen_string_literal: true

class CreateExamRegistrations < ActiveRecord::Migration[7.1]
  def change
    create_table :exam_registrations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :exam_window, null: false, foreign_key: true

      t.timestamps
    end
    add_index :exam_registrations, [:user_id, :exam_window_id]
  end
end
