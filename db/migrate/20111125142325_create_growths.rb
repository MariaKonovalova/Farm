class CreateGrowths < ActiveRecord::Migration
  def change
    create_table :growths do |t|
      t.integer :stage

      t.timestamps
    end
  end
end
