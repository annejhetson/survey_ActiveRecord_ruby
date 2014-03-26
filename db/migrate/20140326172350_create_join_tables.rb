class CreateJoinTables < ActiveRecord::Migration
  def change
    create_table :joins do |t|
    t.belongs_to :survey
    t.belongs_to :answer

    t.timestamps
    end
  end
end
