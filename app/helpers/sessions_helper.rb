module SessionsHelper

  # 引数に渡されたユーザーオブジェクトでログインします。
  def log_in(user)
    session[:user_id] = user.id  # session ﾒｿｯﾄﾞ【flash 変数に似ている】
                                 # ﾛｸﾞｲﾝしたuser_id を sessionのuser_id に代入
                                 # 例) session[:user_id] = '1'
                                 # 例) flash.now[:danger] = '認証に失敗しました'
  end
end