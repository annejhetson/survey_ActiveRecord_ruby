class ModifyQuestionsAnswers < ActiveRecord::Migration
  def down
    drop_table :questions_answers
  end

  # def change
  #   create_table :questions_answers do |t|
  #   t.belongs_to :question
  #   t.belongs_to :answer


  #   t.timestamps
  #   end
end
