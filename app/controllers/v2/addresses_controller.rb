class V2::AddressesController < ApplicationController
  before_action :set_contact
  
  def update
    if @contact.address.update(address_params)
      render jsonapi: @contact.address
    else
      render jsonapi_errors: @contact.address.errors, status: :unprocessable_entity
    end
  end

  def create
    @address = Address.new(address_params.merge({contact: @contact}))

    if @address.save
      render jsonapi: @contact.address, status: :created, location: "http://localhost:2002/contacts/#{@contact.id}/address?version=2.0"
    else
      render jsonapi_errors: @address.errors, status: :unprocessable_entity
    end
  end
 
  def show
    @address = @contact.address

    render jsonapi: @address, include: [:contact]
  end

  def jsonapi_object
    { version: '2.0' }
  end

  def jsonapi_class
    super.merge(
      Kind: V2::SerializableKind,
      Contact: V2::SerializableContact
    )
  end

  private
    # Set contact for actions searches.
    def set_contact
      @contact = Contact.find(params[:contact_id])
    end

    # Only allow a list of trusted parameters through.
    def address_params
      ActionController::Parameters.new(deserialized).permit(
        :street, :city
      )
    end

    # Deserializes incoming json.
    def deserialized
      deserialized = DeserializableAddress.call(params[:data].as_json)
    end
end
