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
    
      # ログイン後にユーザー情報ページにリダイレクトします。
    else
      # ここにはエラーメッセージ用のflashを入れます。
      render :new
    end
  end
end