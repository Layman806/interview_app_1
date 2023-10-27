# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Register', type: :request do
  describe 'GET /new' do

    context 'For sane params' do
      before do
        my_college = FactoryBot.create(:college)
        my_exam = FactoryBot.create(:exam, college_id: my_college.id)
        FactoryBot.create(:exam_window,
                          exam_id: my_exam.id,
                          start_time: '28-Oct-2023',
                          end_time: '3-Nov-2023')
        my_params = {
          first_name: 'John',
          last_name: 'Doe',
          phone_number: '+91-9876543210',
          college_id: my_college.id,
          exam_id: my_exam.id,
          start_time: '1-Nov-2023'
        }
        get '/register', params: my_params
      end

      it 'returns success response' do
        expect(response.status).to eq(200)
      end
    end

    context 'For valid params but non-existent college id and exam id' do
      before do
        my_params = {
          first_name: 'John',
          last_name: 'Doe',
          phone_number: '+91-9876543210',
          college_id: 1,
          exam_id: 1,
          start_time: '1-Nov-2023'
        }
        get '/register', params: my_params
      end

      it 'returns all errors with error status' do
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['errors'])
          .to contain_exactly('College id not valid',
                              'Exam id not valid',
                              'Start time not in any exam window')
      end
    end

    context 'For valid params but invalid start time' do
      before do
        my_college = FactoryBot.create(:college)
        my_exam = FactoryBot.create(:exam, college_id: my_college.id)
        my_params = {
          first_name: 'John',
          last_name: 'Doe',
          phone_number: '+91-9876543210',
          college_id: my_college.id,
          exam_id: my_exam.id,
          start_time: '1-Nov-2023'
        }
        get '/register', params: my_params
      end

      it 'returns error with error status' do
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['errors'])
          .to contain_exactly('Start time not in any exam window')
      end
    end

    context 'Failure for no params scenario' do
      before do
        get '/register'
      end

      it 'returns 400' do
        expect(response.status).to eq(400)
      end
    end

    context 'Failure for some params missing' do
      before do
        get '/register', params: {
          first_name: 'John',
          college_id: 1
        }
      end

      it 'returns 400' do
        expect(response.status).to eq(400)
      end
    end

    # If you want to keep tests into one object, in the case of too many parameter samples
    # to check for.
    #
    # it 'tests' do
    #   [
    #     [
    #       'Success scenario',
    #       {
    #         first_name: 'John',
    #         last_name: 'Adams',
    #         phone_number: '+91-9876543210',
    #         college_id: 1,
    #         exam_id: 1,
    #         start_time: '10:30'
    #       }, 200
    #     ],
    #     [
    #       'Error when missing all params',
    #       {},
    #       400
    #     ],
    #     [
    #       'Error when missing some params',
    #       {
    #         first_name: 'John',
    #         exam_id: 1
    #       },
    #       400
    #     ],
    #   ].each do |_, params, expected_status|
    #     get '/register', params: params
    #     expect(response.status).to eq(expected_status)
    #   end
    # end
  end
end
