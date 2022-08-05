class DeserializableKind < JSONAPI::Deserializable::Resource
  attribute(:description) do |val|
    { 'description'.to_sym => val }
  end
  has_many :contacts
end
