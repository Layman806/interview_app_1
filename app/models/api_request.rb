# frozen_string_literal: true

class ApiRequest < ApplicationRecord
  validate :college_presence, :exam_presence,
           :exam_college_association

  INVALID_COLLEGE_ID = 'College id not valid'
  INVALID_EXAM_ID = 'Exam id not valid'
  EXAM_AND_COLLEGE_NOT_ASSOCIATED = 'Exam does not belong to this college'
  START_TIME_OUT_OF_RANGE = 'Start time not in any exam window'
  INVALID_USER = 'User not valid'

  def run
    # binding.pry
    begin
      @my_user ||= User.find_or_create_by(first_name: request_params['first_name'],
                             last_name: request_params['last_name'],
                             phone_number: request_params['phone_number'])
      unless @my_user.valid?
        errors.add(:base, INVALID_USER)
        return false
      end
      unless start_time_with_exam_window?
        errors.add(:base, START_TIME_OUT_OF_RANGE)
        return false
      end
      ExamRegistration.find_or_create_by(user_id: @my_user.id,
                                         exam_window_id: @valid_exam_windows.first.id)
    rescue ActiveRecord::RecordNotUnique
      return false
    end
  end

  private

  def college_presence
    # binding.pry
    begin
      @my_college ||= College.find(request_params['college_id'])
    rescue ActiveRecord::RecordNotFound
      errors.add(:base, INVALID_COLLEGE_ID)
    end
  end

  def exam_presence
    begin
      @my_exam ||= Exam.find(request_params['exam_id'])
    rescue ActiveRecord::RecordNotFound
      errors.add(:base, INVALID_EXAM_ID)
    end
  end

  def exam_college_association
    if @my_college.nil? or @my_exam.nil?
      return
    end
    if @my_college.id != @my_exam.college_id
      errors.add(:base, EXAM_AND_COLLEGE_NOT_ASSOCIATED)
    end
  end

  def start_time_with_exam_window?
    # binding.pry
    @valid_exam_windows ||= ExamWindow.where('? BETWEEN start_time AND end_time',
                         request_params['start_time'])
    not @valid_exam_windows.empty?
  end
end
