class Phone < ApplicationRecord
  belongs_to :contact

  validates_presence_of :number
end
