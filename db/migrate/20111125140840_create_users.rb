class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password

      t.timestamps
    end

    create_table :fields do |t|
      t.references :user
      t.integer :zero_x
      t.integer :zero_y
      t.integer :size_x
      t.integer :size_y

      t.timestamps
    end
  end
end
