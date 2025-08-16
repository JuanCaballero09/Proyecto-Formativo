class Dashboard::OrdersController < ApplicationController
  layout "dashboard"

  before_action :authenticate_user!
  before_action :check_admin
  before_action :check_employee

  def index
    @orders = Order.includes(:user, :order_items).order(created_at: :desc)
  end

  def show
    @order = Order.find_by!(code: params[:id])
  end

  def employee
    @orders = Order.includes(:user, :order_items).where(status: [ :pagado, :en_preparacion, :enviado, :entregado, :cancelado ]).order(created_at: :asc)
  end

  def cambiar_estado
    @order = Order.find(params[:id])
    if @order.update(status: params[:estado])
      redirect_to employee_dashboard_orders_path, notice: "Orden actualizada"
    else
      redirect_to employee_dashboard_orders_path, alert: "No se pudo actualizar la orden"
    end
  end

  def cancelar
    @order = Order.find(params[:id])
    if @order.update(status: "cancelado")
      redirect_to employee_dashboard_orders_path, alert: "Orden cancelada"
    else
      redirect_to employee_dashboard_orders_path, alert: "No se pudo cancelar la orden"
    end
  end

  private

  def check_admin
    if current_user.admin?
      true
    else
      false
    end
  end

  def check_employee
    if current_user.empleado?
      true
    else
      false
    end
  end

  def check_access
    return true if check_admin
    return true if check_employee

    redirect_to root_path, alert: "No tienes acceso a esta página."
  end
end
