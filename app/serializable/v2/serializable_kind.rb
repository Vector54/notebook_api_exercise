class V2::SerializableKind < JSONAPI::Serializable::Resource
  type 'kinds'
  attributes :description, :created_at, :updated_at
  has_many :contacts
end
