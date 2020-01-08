class User < ApplicationRecord  # Userクラスが定義されていること
                                # UserクラスはApplicationRecordクラスを継承していること
                                # この継承の働きによりActive Recordのメソッドが使えると
  
  before_save { self.email = email.downcase } # メールの大文字部分を自動で小文字にするﾒｿｯﾄﾞ
# before_save ﾒｿｯﾄﾞ = オブジェクトが保存される時点で処理を実行
  
  validates :name, presence: true, length: { maximum: 50 }
# presence: trueという引数は1つのハッシュとして考えます 👈少し意味ぷー 4.4より
# 👆 validates(:name, presence: true) と同意 4.4より

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
# 👆mailの正規表現の有効      👆フォーマット
#   正規表現を代入しているVALID_EMAIL_REGEXは、
#   値が変化することがないため定数として定義しています。

  validates :email, presence: true, length: { maximum: 100},
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
end
