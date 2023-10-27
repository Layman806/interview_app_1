# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  it 'is invalid for first_name with non-alphabetic chars' do
    my_user = FactoryBot.build_stubbed(:user, first_name: '1A')
    expect(my_user.valid?).to be_falsey
  end
  it 'is invalid for last_name with non-alphabetic chars' do
    my_user = FactoryBot.build_stubbed(:user, last_name: '1A')
    expect(my_user.valid?).to be_falsey
  end
  it 'is invalid for incorrect length phone number(!10)' do
    my_user = FactoryBot.build_stubbed(:user, phone_number: '987654321')
    expect(my_user.valid?).to be_falsey
  end
end
