class DeletePlants < ActiveRecord::Migration
  def up
    drop_table :plants
  end

  def down
    create_table :plants do |t|
      t.references :field
      t.integer :x
      t.integer :y
      t.references :element_type
      t.references :growth_stage, :default => 1

      t.timestamps
    end
  end
end
