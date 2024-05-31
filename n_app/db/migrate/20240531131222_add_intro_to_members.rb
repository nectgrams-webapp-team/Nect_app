class AddIntroToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :intro, :string
  end
end
