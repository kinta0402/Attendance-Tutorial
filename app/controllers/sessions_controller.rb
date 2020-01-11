class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
      # ネスト構造のハッシュの値を取得している【入力されたemailを取得】
      # ハッシュの中にハッシュがある↓
      # { session: { email: "sample@email.com", password: "password" } }
    if user && user.authenticate(params[:session][:password]) # 6.2.2に記載されてる
      # ⓵ユーザーオブジェクトが見つからなかった場合、パスワードは何を入力しても判定はfalse
      # ⓶有効なユーザーオブジェクトが取得できたが、パスワードは間違っている場合の判定はfalse
      # ⓷有効なユーザーオブジェクトが取得でき、パスワードも一致した場合の判定はtrue
      
      log_in user # session_helper にて定義 【sessionに保存されたuser_idを取得】(6.3.1参照)
        # userオブジェクトのidをsession(cookie) に保存
      redirect_to user
        # redirect_to user_url(@user) 👆railsでは左記のコードのように実行したいことを判断してくれます
    else
      flash.now[:danger] = '認証に失敗しました'
        # flash変数のみだと、ﾘﾀﾞｲﾚｸﾄしていない為、ﾌﾗｯｼｭﾒｯｾｰｼﾞがずっと表示されてしまう。
        # ⇒ それを防ぐ為、flash.now にしている (6.2.3 参照)
      render :new
    end
  end
end