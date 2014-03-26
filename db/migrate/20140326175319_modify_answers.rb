class ModifyAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :survey_id, :integer
  end
end
