class SessionsController < ApplicationController
  
  # Session は モデルを作成せず。 1対1(userと比較)
  # Attendance は モデルを作成した。1対多(userと比較)
  # この違いがよく分からん

  def new
  end

  # ログイン処理 (一見するとcreateアクションの為、ユーザー登録っぽいが、これはsession cntroller内！！) 
  
  def create # 注) ここはsessionﾒｿｯﾄﾞではなく、sessionカラム(ハッシュのキー)!?
             #     ⇒ session[:user_id]  sessonメソッドではない
    user = User.find_by(email: params[:session][:email].downcase)
      # ネスト構造のハッシュの値を取得している【入力されたemailを取得】
      # ハッシュの中にハッシュがある↓
      # { session: { email: "sample@email.com", password: "password" } }
      # Userﾃｰﾌﾞﾙに、ログインで入力されたemailがあるか確認
    if user && user.authenticate(params[:session][:password]) # 6.2.2に記載されてる
      # ⓵ユーザーオブジェクトが見つからなかった場合、パスワードは何を入力しても判定はfalse
      # ⓶有効なユーザーオブジェクトが取得できたが、パスワードは間違っている場合の判定はfalse
      # ⓷有効なユーザーオブジェクトが取得でき、パスワードも一致した場合の判定はtrue
      
      # ログイン出来れば、session変数(cookies)にuser_idを保存
      log_in user # session_helper にて定義 【sessionに保存されたuser_idを取得】(6.3.1参照)
        # log_in(user) ⇒ 上記は引数として指定する為の()を省略して記述
        # userオブジェクトのidをsession(cookie) に保存
        
      # remember_me ﾁｪｯｸﾎﾞｯｸｽがオン時とオフ時の処理 三項演算子を使用 ⇒ 7.3 参照
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      
      # redirect_to user
      #   # 引数のuser の()を省略
      #   # redirect_to user_url(@user) 👆railsでは左記のコードのように実行したいことを判断してくれます
      # 👆がフレンドリーフォワーディング機能追加で👇に変更 8.3参照
      redirect_back_or user
    else
      flash.now[:danger] = '認証に失敗しました'
        # flash変数のみだと、ﾘﾀﾞｲﾚｸﾄしていない為、ﾌﾗｯｼｭﾒｯｾｰｼﾞがずっと表示されてしまう。
        # ⇒ それを防ぐ為、flash.now にしている (6.2.3 参照)
      render :new
    end
  end

  def destroy
    # log_out 👈 最初はこのメソッドのみ 7.2 のバグを修正する為
    
    # ログイン中の場合のみログアウト処理を実行します。 
    log_out if logged_in?
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end
end