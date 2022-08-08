class SerializablePhone < JSONAPI::Serializable::Resource
  type 'phones'
  attributes :number, :created_at, :updated_at
  
  belongs_to :contact do
    link(:related) {"http://localhost:3000/contacts/#{@object.contact.id}"}
  end
end
