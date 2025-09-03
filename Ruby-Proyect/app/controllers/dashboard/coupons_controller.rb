class Dashboard::CouponsController < ApplicationController
  layout "dashboard"

  before_action :set_coupon, only: [:show, :edit, :update, :destroy] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
  before_action :authenticate_user!
  before_action :check_admin
  def index
    @coupons = Coupon.order(created_at: :desc)
  end

  def show
  end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.new(coupon_params)
    if @coupon.save
      redirect_to dashboard_coupon_path(@coupon), notice: "Cupón creado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end
  def edit
  end

  def update
    if @coupon.update(coupon_params)
      redirect_to dashboard_coupon_path(@coupon), notice: "Cupón actualizado."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @coupon.destroy
    redirect_to dashboard_coupons_path, notice: "Cupón eliminado."
  end

  private

  def set_coupon
    @coupon = Coupon.find(params[:id])
  end

  def coupon_params
    params.require(:coupon).permit(:code, :discount_type, :discount_value, :expires_at, :active)
  end

  def check_admin
    unless current_user.admin?
      redirect_to root_path, alert: "No tienes acceso a esta página."
    end
  end
end
