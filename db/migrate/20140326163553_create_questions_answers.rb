class CreateQuestionsAnswers < ActiveRecord::Migration
  def change
    create_table :questions_answers do |t|
    t.column :question_id, :integer
    t.column :answer_id, :integer


    t.timestamps
    end
  end
end
