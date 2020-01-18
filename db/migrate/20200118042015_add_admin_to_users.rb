class AddAdminToUsers < ActiveRecord::Migration[5.1]
  # admin 属性を追加
  def change
    add_column :users, :admin, :boolean, default: false
  end
end
