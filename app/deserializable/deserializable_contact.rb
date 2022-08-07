class DeserializableContact < JSONAPI::Deserializable::Resource
  attributes :name, :email, :birthdate, :phones_attributes, :address_attributes, :kind_id  
  has_one :kind do |rel, id, type|
    Hash[kind_id: id]
  end
end