class Dashboard::OrdersController < ApplicationController
  layout "dashboard"

  before_action :authenticate_user!
  before_action :check_admin

  def index
    @orders = Order.includes(:user, :order_items).order(created_at: :desc)
  end

  def show
    @order = Order.find_by!(code: params[:id])
  end

  private

  def check_admin
    redirect_to root_path, alert: "No tienes acceso a esta página." unless current_user.admin?
  end
end
