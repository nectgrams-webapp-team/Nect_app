class ChangeDataIntroToMembers < ActiveRecord::Migration[7.1]
  def change
    change_column :members, :intro, :text
  end
end
