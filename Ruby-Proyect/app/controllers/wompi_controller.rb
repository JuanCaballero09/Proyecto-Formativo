class WompiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def webhook
    Rails.logger.info "WOMPI WEBHOOK: #{params.inspect}"
    transaction = params.dig(:data, :transaction) || params.dig("data", "transaction")
    transaction_id = transaction[:id] || transaction["id"]
    wompi_status = transaction[:status] || transaction["status"]

    status_map = {
      "APPROVED" => "approved",
      "DECLINED" => "declined",
      "PENDING"  => "pending",
      "VOIDED"   => "cancelled"
    }
    local_status = status_map[wompi_status.to_s.upcase] || "pending"

    payment = Payment.find_by(transaction_id: transaction_id)
    Rails.logger.info "PAYMENT FOUND: #{payment.inspect}"
    if payment
      payment.update(status: local_status)
      Rails.logger.info "PAYMENT UPDATED TO: #{local_status}"
    else
      Rails.logger.info "PAYMENT NOT FOUND"
    end

    head :ok
  end
end
