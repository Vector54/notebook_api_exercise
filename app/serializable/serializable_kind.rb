class SerializableKind < JSONAPI::Serializable::Resource
  type 'kinds'
  attribute :description
  attribute :created_at
  attribute :updated_at
  has_many :contacts
end
