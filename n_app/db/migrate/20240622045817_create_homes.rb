class CreateHomes < ActiveRecord::Migration[7.1]
  def change
    create_table :homes do |t|
      t.string :title
      t.string :caption
      t.string :file
      t.timestamps
    end
  end
end
