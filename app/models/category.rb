class Category < ApplicationRecord
	has_many :event, dependent: :restrict_with_error
end