class DeleteUsers < ActiveRecord::Migration
  def up
    drop_table :users
  end

  def down
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password

      t.timestamps

      t.timestamps
    end
  end
end
