class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.belongs_to :user

      t.timestamps
    end
    add_index :students, :user_id
  end
end
