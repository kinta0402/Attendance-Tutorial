module SessionsHelper

  # 注) ここはsesssionメソッド
  # 引数に渡されたユーザーオブジェクトでログインします。
  def log_in(user)
    session[:user_id] = user.id  # session ﾒｿｯﾄﾞ【flash 変数に似ている】
                                 # ﾛｸﾞｲﾝしたuser_id を sessionのuser_id に代入
                                 # 例) session[:user_id] = '1'
                                 # 例) flash.now[:danger] = '認証に失敗しました'
  end
  
  # 永続的セッションを記憶します（Userモデルを参照）# 7.1.3
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
    # 永続的セッションを破棄します
  def forget(user)
    user.forget # Userモデル参照
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # セッションと@current_userを破棄します。
  def log_out
    forget(current_user) # 一段👆のforgetメソッドの( user ) 引数に current_user を渡してる 7.1.4
    session.delete(:user_id)   # session に保存されたid を削除
   # セッションからユーザーIDを削除しただけでは@current_userに代入されたユーザーオブジェクトは削除されない為、
   # current_user の値もnil にする
    @current_user = nil        
  end


  # 現在ログイン中のユーザーがいる場合オブジェクトを返します..
  # 現在ログインしているユーザーの値を取得
  def current_user
    # if session[:user_id]    ※１回目
    #   if @current_user.nil?
    #     @current_user = User.find_by(id: session[:user_id])
    #   else
    #     @current_user
    # end
    
    # 👆の省略形 👇   ※ 2回目
    # if session[:user_id]
    #   @current_user ||= User.find_by(id: session[:user_id])  # この式はややこしい 6.3.2に記載
    # end
    
    # 👆remember 計追加(理解しなくてOK)👇 ※ ３回目
    
    # 一時的セッションにいるユーザーを返します。
    # それ以外の場合はcookiesに対応するユーザーを返します。
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  
  # 渡されたユーザーがログイン済みのユーザーであればtrueを返します。
  def current_user?(user)
    user == current_user
  end
  
  # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返します。
  def logged_in?
    !current_user.nil?
    
      
  # 否定演算子! すぐに頭にうかばない為、書いて理解しよう！！ 👇はあまりまとまってない（笑）
  # current_user nil？ true ⇒  !で false
                      # false ⇒ ! で true  
  # current_user はnil じゃない？(ログイン中のユーザーはいますか？) ⇒ true
  end
  
  
  # 以下2つのメソッドは 8.3 フレンドリーフォワーディング機能 8.3 ⇒ いらないと思う為、真剣に考えてない
  
  # 記憶しているURL(またはデフォルトURL)にリダイレクトします。
  def redirect_back_or(default_url)
    redirect_to(session[:forwarding_url] || default_url)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを記憶します。
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end