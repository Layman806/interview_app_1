# frozen_string_literal: true

class User < ApplicationRecord
  validates :first_name, format: { with: /\A[a-zA-Z]+\z/ }
  validates :last_name, format: { with: /\A[a-zA-Z]+\z/ }
  validates :phone_number, format: { with: /\d{10}/ }
end
