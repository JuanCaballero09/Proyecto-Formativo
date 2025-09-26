class Dashboard::DashboardController < ApplicationController
  layout "dashboard"

  before_action :authenticate_user!
  before_action :check_access # Verifica si el usuario tiene acceso a la sección del dashboard


  def index
    load_charts_data
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
      # Evitamos bucle si ya está en la ruta de employee
      unless request.path == employee_dashboard_orders_path
        redirect_to employee_dashboard_orders_path, notice: "Bienvenido al dashboard de empleado."
      end
      true
    else
      false
    end
  end

  def check_access
    return true if check_admin
    return true if check_employee

    redirect_to root_path, alert: "No tienes acceso a esta página." # Redirige si no es admin ni empleado
  end

  def load_charts_data
    @products_by_group = Product.joins(:grupo).group("grupos.nombre").count
    @grupos_growth = Grupo.group_by_month(:created_at, format: "%b %Y").count
    @top_products = OrderItem.joins(:product).group("products.nombre").order("SUM(order_items.quantity) DESC").limit(5).sum(:quantity)
    @sales_by_day = Order.group("DATE(created_at)").sum(:total)
    @sales_by_week = Order.group("DATE_TRUNC('Week', created_at)").sum(:total)
    @sales_by_month = Order.group("DATE_TRUNC('month', created_at)").sum(:total)
  end
end
