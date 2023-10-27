# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiRequest do
  before do
    @my_college = FactoryBot.create(:college)
    @my_exam = FactoryBot.create(:exam, college_id: @my_college.id)
    @my_exam_window = FactoryBot.create(:exam_window,
                                        exam_id: @my_exam.id,
                                        start_time: '28-Oct-2023',
                                        end_time: '3-Nov-2023')
    @my_user = FactoryBot.build_stubbed(:user)
    @my_exam_registration = FactoryBot.build_stubbed(:exam_registration)
  end

  it 'passes for college and exam id in db' do
    request_params = {
      'college_id': @my_college.id,
      'exam_id': @my_exam.id,
      'start_time': '1-Nov-2023'
    }
    api_request = FactoryBot.build_stubbed(:api_request, request_params: request_params)
    expect(api_request.valid?).to be_truthy
  end

  it 'fails for college with id not in db' do
    request_params = {
      'college_id': @my_college.id + 1,
      'exam_id': @my_exam.id,
      'start_time': '1-Nov-2023'
    }
    api_request = FactoryBot.build_stubbed(:api_request, request_params: request_params)
    expect(api_request.valid?).to be_falsey
  end

  it 'fails for exam with id not in db' do
    request_params = {
      'college_id': @my_college.id,
      'exam_id': @my_exam.id + 1,
      'start_time': '1-Nov-2023'
    }
    api_request = FactoryBot.build_stubbed(:api_request, request_params: request_params)
    expect(api_request.valid?).to be_falsey
  end

  it 'fails for exam not associated to college mentioned in college_id' do
    different_college = FactoryBot.create(:college)
    unassociated_exam = FactoryBot.create(:exam, college_id: different_college.id)
    request_params = {
      'college_id': @my_college.id,
      'exam_id': unassociated_exam.id,
      'start_time': '1-Nov-2023'
    }
    api_request = FactoryBot.build_stubbed(:api_request, request_params: request_params)
    expect(api_request.valid?).to be_falsey
  end

  it 'passes when user found/created for request' do
    my_user = FactoryBot.create(:user)
    allow(User).to receive(:find_or_create_by)
                     .with(first_name: 'John',
                           last_name: 'Doe',
                           phone_number: '1234567890')
                     .and_return(my_user)
    # allow(ExamWindow).to receive(:where)
    #                              .with(user_id: @my_user.id,
    #                                    exam_window: @my_exam_window.id)
    request_params = {
      'first_name': 'John',
      'last_name': 'Doe',
      'phone_number': '1234567890',
      'college_id': @my_college.id,
      'exam_id': @my_exam.id,
      'start_time': '1-Nov-2023'
    }
    api_request = FactoryBot.build_stubbed(:api_request, request_params: request_params)
    expect(api_request.run).to be_truthy
  end
  # Below spec is to deal with the case if the application has to run
  # in high concurrency and that user should be uniq on all three
  # fields. This is because find_or_create_by is NOT ATOMIC, and can
  # raise the ActiveRecord::RecordNotUnique exception.
  it 'fails when user not created for request' do
    allow(User).to receive(:find_or_create_by)
                     .with(first_name: 'John',
                           last_name: 'Doe',
                           phone_number: '1234567890')
                     .and_raise(ActiveRecord::RecordNotUnique)
    request_params = {
      'first_name': 'John',
      'last_name': 'Doe',
      'phone_number': '1234567890',
      'college_id': @my_college.id,
      'exam_id': @my_exam.id,
      'start_time': '1-Nov-2023'
    }
    api_request = FactoryBot.build_stubbed(:api_request, request_params: request_params)
    expect(api_request.run).to be_falsey
  end
  it 'passes for start time provided in any exam window' do

    request_params = {
      'first_name': 'John',
      'last_name': 'Doe',
      'phone_number': '1234567890',
      'college_id': @my_college.id,
      'exam_id': @my_exam.id,
      'start_time': '1-Nov-2023'
    }
    api_request = FactoryBot.build_stubbed(:api_request, request_params: request_params)
    expect(api_request.run).to be_truthy
  end
  it 'fails for start time NOT provided in any exam window' do
    request_params = {
      'first_name': 'John',
      'last_name': 'Doe',
      'phone_number': '1234567890',
      'college_id': @my_college.id,
      'exam_id': @my_exam.id,
      'start_time': '5-Nov-2023'
    }
    api_request = FactoryBot.build_stubbed(:api_request, request_params: request_params)
    expect(api_request.run).to be_falsey
  end
  it 'finds/creates user in exam registrations' do
    request_params = {
      'first_name': 'John',
      'last_name': 'Doe',
      'phone_number': '1234567890',
      'college_id': @my_college.id,
      'exam_id': @my_exam.id,
      'start_time': '1-Nov-2023'
    }
    allow(ExamRegistration).to receive(:find_or_create_by)
                                 .and_return(@my_exam_registration)
    api_request = FactoryBot.build_stubbed(:api_request, request_params: request_params)
    expect(api_request.run).to be_truthy
  end
  it 'fails for invalid user' do
    request_params = {
      'first_name': '1A',
      'last_name': '2B',
      'phone_number': '1234567890',
      'college_id': @my_college.id,
      'exam_id': @my_exam.id,
      'start_time': '1-Nov-2023'
    }
    invalid_user = FactoryBot.build_stubbed(:user, first_name: '1A', last_name: '2B', phone_number: '1234567890')
    api_request = FactoryBot.build_stubbed(:api_request, request_params: request_params)
    allow(User).to receive(:find_or_create_by)
                     .and_return(invalid_user)
    expect(api_request.run).to be_falsey
  end
end
