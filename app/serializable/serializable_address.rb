class SerializableAddress < JSONAPI::Serializable::Resource
  type 'addresses'
  attributes :street, :city, :created_at, :updated_at

  belongs_to :contact do
    link(:related) {"http://localhost:3000/contacts/#{@object.contact.id}"}
  end
end
