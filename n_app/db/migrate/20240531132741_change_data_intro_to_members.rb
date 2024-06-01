class ChangeDataIntroToMembers < ActiveRecord::Migration[7.1]
  def up
    change_column :members, :intro, :text
  end

  def down
    change_column :members, :intro, :string
  end
end
