class Coin < ApplicationRecord
	has_many :event, dependent: :restrict_with_error

	mount_uploader :logo, CoinLogoUploader
end
