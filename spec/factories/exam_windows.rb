# frozen_string_literal: true

FactoryBot.define do
  factory :exam_window do
    start_time { '2023-10-25' }
    end_time { '2023-10-25' }
    exam { nil }
  end
end
