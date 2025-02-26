class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    getWeek
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def getWeek
    week_days = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']
  
    @todays_date = Date.today
    @week_days = []
  
    plans = Plan.where(date: @todays_date..@todays_date + 7)
  
    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end
  
      # 曜日を取得し、daysハッシュに追加
      wday = (@todays_date + x).wday # wdayメソッドで曜日（0=日曜, 1=月曜, ..., 6=土曜）を取得
      days = { 
        month: (@todays_date + x).month, 
        date: (@todays_date + x).day, 
        wday: week_days[wday], # 曜日を追加
        plans: today_plans
      }
  
      @week_days.push(days)
    end
  end
end