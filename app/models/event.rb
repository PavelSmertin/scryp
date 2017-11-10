class Event < ApplicationRecord
	belongs_to :coin
	has_many :newest, dependent: :restrict_with_error
end
