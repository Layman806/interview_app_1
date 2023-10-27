# frozen_string_literal: true

class CreateApiRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :api_requests do |t|
      t.jsonb :request_params

      t.timestamps
    end
  end
end
