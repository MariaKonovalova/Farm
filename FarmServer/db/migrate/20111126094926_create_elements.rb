class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements do |t|
      t.references :element_type
      t.references :growth
      t.string :url_pic

      t.timestamps
    end
  end
end
