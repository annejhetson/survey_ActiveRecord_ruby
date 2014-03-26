class ModifySurveys < ActiveRecord::Migration
  def change
    rename_column :surveys, :question, :survey_title
  end
end
