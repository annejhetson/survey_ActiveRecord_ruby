class Modify2Answers < ActiveRecord::Migration
  def change
    rename_column :answers, :survey_id, :question_id
  end
end
