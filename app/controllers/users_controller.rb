class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    # debugger # ｲﾝｽﾀﾝｽ変数を定義した直後にこのﾒｿｯﾄﾞが実行されます。
  end
  
  def new
    @user = User.new
  end
  
  def create
    # @user = User.new(params[:user]) 現在のrailsのバージョンでは使用出来ない為下記のように記載
    # user_params は private に定義【strong parameters】を使用
    @user = User.new(user_params)
    if @user.save
      # 保存に成功した場合は、ここに記述した処理が実行されます。
    else
      render :new
    end
  end
  
  
  private # 以下はstrong parameters !?
  
    def user_params # 5.5.3 参照
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
end
