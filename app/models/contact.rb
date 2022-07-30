class Contact < ApplicationRecord
  belongs_to :kind
  has_many :phones
  has_one :address

  accepts_nested_attributes_for :phones, allow_destroy: true
  accepts_nested_attributes_for :address, update_only: true

  def author
    "Victor de Oliveira"
  end

  def as_json(options={})
    h = super(options)
    h[:birthdate] = I18n.l(self.birthdate) unless self.birthdate.blank?
    h
  end
end
