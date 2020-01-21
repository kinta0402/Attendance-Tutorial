class UsersController < ApplicationController
  # before_action :set_user, only: [:show, :edit, :update, :destroy]
  # before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  # before_action :correct_user, only: [:edit, :update]
  # before_action :admin_user, only: :destroy
  # モーダル後👇
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  
  def index
    # @users = User.all  ページネーション機能追加の為下記に変更
    @users = User.paginate(page: params[:page]) # 特殊なpaginateメソッド(あまり説明無) 8.4.2
  end
  
  def show
    # @user = User.find(params[:id]) ⇒ 他のアクションでも実行している為、before_action :set_user にまとめた。
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

  def edit
    # @user = User.find(params[:id]) ⇒ 他のアクションでも実行している為、before_action :set_user にまとめた。
  end
  
  def update
    # @user = User.find(params[:id]) ⇒ 他のアクションでも実行している為、before_action :set_user にまとめた。
    if @user.update_attributes(user_params) # データベースの値を複数同時更新 / 更新前にvalidationも実行 (ネットより) ⇒ ｶﾘｷｭﾗﾑには説明ない！！
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
  end
  
  private # 以下はstrong parameters !?
  
    def user_params # 5.5.3 参照
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end


    # beforeフィルター
    
    
    # paramsハッシュからユーザーを取得します。
    def set_user
      @user = User.find(params[:id])
    end
    
    # ログイン済みのユーザーか確認します。
    def logged_in_user
      unless logged_in?
        store_location   
      # フレンドリーフォワーディング機能 8.3参照 ※ログインしないで、URL直打ちでeditページ等に
      # リクエストした際、そのurlをsessionに保存 (session_helperに定義)
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    # アクセスしたユーザーが現在ログインしているユーザーか確認します。
    def correct_user
      @user = User.find(params[:id])
    # redirect_to(root_url) unless @user == current_user
    # 上記をより読み手に分かりやすくする為、session_helperにcurrent_user? を定義 8.2.2参照
      redirect_to(root_url) unless current_user?(@user) 
    end
    
    # システム管理権限所有かどうか判定します。8.5.2
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
