class CreateUsers < ActiveRecord::Migration[5.1]
  def change # データベースに与える変更を定義したchangeメソッドの集まり
    create_table :users do |t| # |t| = ブロック変数
      t.string :name
      t.string :email

      t.timestamps # 自動的に生成される特別なコード
                   # created_at（datetime型)
                   # updated_at（datetime型）という2つのﾏｼﾞｯｸｶﾗﾑを生成
    # interger :id ⇒ ブロック内に記述はないが、自動採番されるIDのカラムも生成される
    end
  end
end
