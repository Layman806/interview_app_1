# frozen_string_literal: true

FactoryBot.define do
  factory :api_request do
    request_params { {
      college_id: 1
    } }
  end
end
