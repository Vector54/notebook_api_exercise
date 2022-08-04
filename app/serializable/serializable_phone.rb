class SerializablePhone < JSONAPI::Serializable::Resource
  type 'phones'
  attribute :number
  attribute :created_at
  attribute :updated_at
  belongs_to :contact
end
