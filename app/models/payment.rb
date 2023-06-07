class Payment < ApplicationRecord
    validates :txid, uniqueness: { message: "*****already paid" }
    validates :card, presence: true
    validates :amount, numericality: {greater_than: 0}

end
