class Admin::DashboardController < Admin::BaseController
  def index
    @orders = Order.preload(:user).by_status
  end
end
