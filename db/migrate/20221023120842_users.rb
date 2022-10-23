class Users < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.timestamps
      t.string :username, null: false
      t.string :password, null: false
    end
  end
end
