class Newest < ApplicationRecord
	belongs_to :event

	mount_uploader :image, NewestImageUploader
end
