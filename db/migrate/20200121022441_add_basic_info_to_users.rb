class AddBasicInfoToUsers < ActiveRecord::Migration[5.1]
  def change
                                              # adminでも設定したが、migrationﾌｧｲﾙ作成後、デフォルト値を設定(9.2)
                                              # ⇒設定後、rails db:migrateコマンド
    add_column :users, :basic_time, :datetime, default: Time.current.change(hour: 8, min: 0, sec: 0)
    add_column :users, :work_time, :datetime, default: Time.current.change(hour: 7, min: 30, sec: 0)
  end
end
