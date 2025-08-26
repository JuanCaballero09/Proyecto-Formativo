class Payment < ApplicationRecord
  belongs_to :order

  enum :status, {
    pending: 0,
    approved: 1,
    declined: 2,
    cancelled: 3
  }

  after_commit :sync_order_status, if: :saved_change_to_status?

  private

  def sync_order_status
    case status
    when "approved"
      order.update(status: :pagado)
      Rails.logger.info "✅ Order #{order.code} marcada como PAGADA"
    when "declined"
      order.update(status: :pendiente) if order.pendiente?
      Rails.logger.info "⚠️ Order #{order.code} sigue en PENDIENTE"
    when "cancelled"
      order.update(status: :cancelado)
      Rails.logger.info "❌ Order #{order.code} CANCELADA"
    end
  end
end
