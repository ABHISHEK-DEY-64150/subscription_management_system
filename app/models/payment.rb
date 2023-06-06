class Payment < ApplicationRecord
    validates :txid, uniqueness: { message: "*****already paid" }
end
