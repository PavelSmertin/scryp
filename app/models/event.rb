class Event < ApplicationRecord
	belongs_to :coin
	belongs_to :category
	has_many :newest, dependent: :restrict_with_error
end
