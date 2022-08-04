class SerializableAddress < JSONAPI::Serializable::Resource
  type 'addresses'
  attribute :street
  attribute :city
  attribute :created_at
  attribute :updated_at
  belongs_to :contact
end
