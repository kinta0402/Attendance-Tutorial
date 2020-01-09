class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    # debugger # ｲﾝｽﾀﾝｽ変数を定義した直後にこのﾒｿｯﾄﾞが実行されます。
  end
  
  def new
    @user = User.new
  end
end
