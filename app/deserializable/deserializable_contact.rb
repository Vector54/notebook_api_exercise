class DeserializableContact < JSONAPI::Deserializable::Resource
  attributes :name, :email, :birthdate, :phones_attributes, :address_attributes, :kind_id  
end