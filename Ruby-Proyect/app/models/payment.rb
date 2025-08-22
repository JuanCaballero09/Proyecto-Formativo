class Payment < ApplicationRecord
  belongs_to :order

  enum :status, {
    pending: 0,
    approved: 1,
    declined: 2,
    error: 3
  }
end
