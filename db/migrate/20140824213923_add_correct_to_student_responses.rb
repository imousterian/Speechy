class AddCorrectToStudentResponses < ActiveRecord::Migration
  def change
    add_column :student_responses, :correct, :boolean
  end
end
