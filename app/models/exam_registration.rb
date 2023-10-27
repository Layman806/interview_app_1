# frozen_string_literal: true

class ExamRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :exam_window
end
