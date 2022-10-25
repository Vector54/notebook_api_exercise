class V1::SerializableContact < JSONAPI::Serializable::Resource
  type 'contacts'

  attributes :name, :email 
  attribute :birthdate do
    @object.birthdate.to_time.iso8601 unless @object.birthdate.blank?
  end
  attribute :created_at
  attribute :updated_at

  link(:self) {"http://localhost:3000/contacts/#{@object.id}"}

  belongs_to :kind do
    link(:self) {"http://localhost:3000/contacts/#{@object.id}/relationships/kind"}
    link(:related) {"http://localhost:3000/contacts/#{@object.id}/kind"}
  end
  has_one :address do
    link(:self) {"http://localhost:3000/contacts/#{@object.id}/relationships/address"}
    link(:related) {"http://localhost:3000/contacts/#{@object.id}/address"}
  end
  has_many :phones do
    link(:self) {"http://localhost:3000/contacts/#{@object.id}/relationships/phones"}
    link(:related) {"http://localhost:3000/contacts/#{@object.id}/phones"}
  end
end
