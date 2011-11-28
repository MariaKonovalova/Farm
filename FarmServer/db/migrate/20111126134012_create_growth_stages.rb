class CreateGrowthStages < ActiveRecord::Migration
  def change
    create_table :growth_stages do |t|
      t.integer :stage

      t.timestamps
    end
  end
end
