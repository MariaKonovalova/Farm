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
      t.integer :zero_x, :default => 0
      t.integer :zero_y, :default => 0
      t.integer :size_x, :default => 60
      t.integer :size_y, :default => 60

      t.timestamps
    end
  end
end
