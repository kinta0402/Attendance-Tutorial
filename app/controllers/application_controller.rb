class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土} # $ = ｸﾞﾛｰﾊﾞﾙ変数 ⇒ ﾌﾟﾛｸﾞﾗﾑのどこからでも呼び出す事の出来る変数 10.3
                                               # %w{} = リテラル表記 10.3
                                               # ["日", "月", "火", "水", "木", "金", "土"]の配列と同じように使えます。
end
