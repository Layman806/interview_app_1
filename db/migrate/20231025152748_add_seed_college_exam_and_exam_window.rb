# frozen_string_literal: true

class AddSeedCollegeExamAndExamWindow < ActiveRecord::Migration[7.1]
  def up
    @my_college ||= College.create(name: 'SomeCollegeABC')
    @my_exam ||= Exam.create(name: 'CS101', college_id: @my_college.id)
    @my_exam_window ||= ExamWindow.create(start_time: '20-Nov-2023',
                      end_time: '22-Nov-2023',
                      exam_id: @my_exam.id)
  end

  def down
    @my_exam_window.destroy
    @my_exam.destroy
    @my_college.destroy
  end
end
