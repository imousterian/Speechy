class CreateStudentResponses < ActiveRecord::Migration
  def change
    create_table :student_responses do |t|
      t.string :emotion
      t.belongs_to :student
      t.belongs_to :tagging

      t.timestamps
    end
    add_index :student_responses, :student_id
    add_index :student_responses, :tagging_id
  end
end
