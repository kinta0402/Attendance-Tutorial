class User < ApplicationRecord  # Userクラスが定義されていること
                                # UserクラスはApplicationRecordクラスを継承していること
                                # この継承の働きによりActive Recordのメソッドが使えると
                                
  # 「remember_token」という仮想の属性を作成します。7.1.2参照
  attr_accessor :remember_token
  
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
  
  has_secure_password  # パスワードをハッシュ化する為のﾒｿｯﾄﾞ ややこしい 4.5参照 
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  # allow_nil: true ⇒ ユーザー編集の際、パスワードが空白でも更新できるようにする！！8.1.4
  # ユーザー新規作成の場合は、has_secure_password が存在性を検証する為OK！！
  
  
    #👇remember_me 機能を実装する為に追加 詳細7.1.1
    
    # 渡された文字列のハッシュ値を返します。
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返します。
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためハッシュ化したトークンをデータベースに記憶します。
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
    # トークンがダイジェストと一致すればtrueを返します。
  def authenticated?(remember_token)
    # ダイジェストが存在しない場合はfalseを返して終了します。 7.2
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
    # ユーザーのログイン情報を破棄します。7.1.4
    # (remember_me機能により、ログイン状態の永続的保持は出来たが、その影響により、ログアウトが出来なくなっていた。
    #   それを防ぐ為、cookiesを削除する)
    # ⇒方法としては、:remember_digestをnilにする！！
  def forget
    update_attribute(:remember_digest, nil)
  end
end
