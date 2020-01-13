class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    # debugger # ｲﾝｽﾀﾝｽ変数を定義した直後にこのﾒｿｯﾄﾞが実行されます。
  end
  
  def new
    @user = User.new
  end
  
  # ユーザー登録
  
  def create
    # @user = User.new(params[:user]) 現在のrailsのバージョンでは使用出来ない為下記のように記載
    # user_params は private に定義【strong parameters】を使用
    @user = User.new(user_params)
    # @user = User.new(name: params[:name], email: params[:email], image: "default.png", password: params[:password] )
    
    if @user.save
      log_in @user # 保存成功後、ログインします。 log_in メソッド ⇒ session_helperに記載
    # log_in(@user) ⇒ ログインメソッドに@userを引数で渡している
    # log_in(id: 1, name: "第一号", email: "sample@email.com", created_at: "2020-01-10 07:06:42", updated_at: "2020-01-10 07:06:42", password_digest: "$2a$12...")
    
      flash[:success] = "新規作成に成功しました。"
      redirect_to @user
      # redirect_to user_url(@user) 👆railsでは左記のコードのように実行したいことを判断してくれます
    else
      render :new
    end
  end
  
  
  private # 以下はstrong parameters !?
  
    def user_params # 5.5.3 参照
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
end
