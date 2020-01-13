module SessionsHelper

  # 注) ここはsesssionメソッド
  # 引数に渡されたユーザーオブジェクトでログインします。
  def log_in(user) # 引数のuser = sessions_controller の create に記載されている user か？
    session[:user_id] = user.id  # session ﾒｿｯﾄﾞ【flash 変数に似ている】
                                 # ﾛｸﾞｲﾝしたuser_id を sessionのuser_id に代入
                                 # 例) session[:user_id] = '1'
                                 # 例) flash.now[:danger] = '認証に失敗しました'
  end
  
  # 現在ログイン中のユーザーがいる場合オブジェクトを返します。
  # 現在ログインしているユーザーの値を取得
  def current_user
    # if session[:user_id]
    #   if @current_user.nil?
    #     @current_user = User.find_by(id: session[:user_id])
    #   else
    #     @current_user
    # end
    
    # 👆の省略形 👇
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])  # この式はややこしい 6.3.2に記載
    end
  end
  
  # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返します。
  def logged_in?
    !current_user.nil?
    
      
  # 否定演算子! すぐに頭にうかばない為、書いて理解しよう！！ 👇はあまりまとまってない（笑）
  # current_user nil？ true ⇒  !で false
                      # false ⇒ ! で true  
  # current_user はnil じゃない？(ログイン中のユーザーはいますか？) ⇒ true
  end

end