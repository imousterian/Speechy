class AddTaglistToStudentResponses < ActiveRecord::Migration
  def change
    add_column :student_responses, :taglist, :string
  end
end
