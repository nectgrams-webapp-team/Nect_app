class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.string :title
      t.text :body
      t.string :post_day
      t.timestamps
    end
  end
end
