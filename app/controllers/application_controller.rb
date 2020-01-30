class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土} # $ = ｸﾞﾛｰﾊﾞﾙ変数 ⇒ ﾌﾟﾛｸﾞﾗﾑのどこからでも呼び出す事の出来る変数 10.3
                                               # %w{} = リテラル表記 10.3
                                               # ["日", "月", "火", "水", "木", "金", "土"]の配列と同じように使えます。
                                               
  # ページ出力前に1ヶ月分のデータの存在を確認・セットします。# ややこしい10.3 10.4
  def set_one_month 
    @first_day = params[:date].nil? ? 
    Date.current.beginning_of_month : params[:date].to_date
    # 👆? = 三項演算子 結果を戻り値として返す？ 10.4 検索要‼
    
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します。
    # ユーザーに紐付く一ヶ月分のレコードを検索し取得します。
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    # ここの@userはshowアクションのインスタンス変数にて定義 詳細⇒10.3
    # @user.attendanes ⇒ UserモデルとAttendanceモデルは1対多の関係の為複数形 ⇒ここのattendancesはモデルを指す
    # .order ⇒ 取得したデータを昇順に並び変える
    
    unless one_month.count == @attendances.count # それぞれの件数（日数）が一致するか評価します。
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        # 繰り返し処理により、1ヶ月分の勤怠データを生成します。
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end

  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
end
