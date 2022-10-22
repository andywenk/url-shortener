class CreateUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :urls do |t|
      t.timestamps
      t.string :source
      t.string :target
    end
  end
end
