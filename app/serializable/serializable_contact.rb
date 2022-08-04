class SerializableContact < JSONAPI::Serializable::Resource
  type 'contacts'

  attributes :name, :email 
  attribute :birthdate do
    @object.birthdate.to_time.iso8601 unless @object.birthdate.blank?
  end
  attribute :created_at
  attribute :updated_at

  link(:self) {"http://localhost:3000/contacts/#{@object.id}"}

  belongs_to :kind do
    link(:related) {"http://localhost:3000/kinds/#{@object.kind_id}"}
  end
  has_one :address
  has_many :phones
end
