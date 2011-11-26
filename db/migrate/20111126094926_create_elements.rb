class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements do |t|
      t.references :element_type
      t.references :growth, :default => 1
      t.string :url_swf

      t.timestamps
    end
  end
end
