class Portfolio < ApplicationRecord
	belongs_to :user
	has_many :portfolio_coin, dependent: :restrict_with_error
end
