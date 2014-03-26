class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.column :answer, :string

      t.timestamps
    end
  end
end
