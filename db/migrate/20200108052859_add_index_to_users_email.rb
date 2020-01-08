class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :email, unique: true
  # 👆 add_index( :users, :email, unique: true) と同意 ※ add_indexﾒｿｯﾄﾞで、usersﾃｰﾌﾞﾙのemailカラムに、indexを追加 (4.4.6より)
  end
end
