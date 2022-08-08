class DeserializablePhone < JSONAPI::Deserializable::Resource
  attributes :number
  id { |i| Hash[id: i] }
end
