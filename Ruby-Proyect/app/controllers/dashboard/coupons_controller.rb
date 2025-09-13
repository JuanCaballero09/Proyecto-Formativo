class Dashboard::CouponsController < ApplicationController
  layout "dashboard"
  before_action :set_coupon, only: [:show, :toggle_activo, :edit, :update, :destroy] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets

  def index
    @coupons = Coupon.all.order(created_at: :desc)
  end

  def toggle_activo
    @coupon.update(activo: !@coupon.activo)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to dashboard_coupons_path, notice: "Estado del cupón actualizado." }
    end
  end

  def show
  end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.new(coupon_params)
    if @coupon.save
      redirect_to dashboard_coupons_path, notice: "Cupón creado correctamente."
    else
      flash.now[:alert] = @coupon.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @coupon.update(coupon_params)
      redirect_to dashboard_coupons_path, notice: "Cupón actualizado correctamente."
    else
      flash.now[:alert] = @coupon.errors.full_messages.to_sentence
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
    params.require(:coupon).permit(:codigo, :tipo_descuento, :valor, :expira_en, :activo)
  end
end
