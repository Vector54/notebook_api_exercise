class AddressesController < ApplicationController
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
      render jsonapi: @contact.address, status: :created, location: contact_address_url(@contact.id)
    else
      render jsonapi_errors: @address.errors, status: :unprocessable_entity
    end
  end
 
  def show
    @address = @contact.address

    render jsonapi: @address, include: [:contact]
  end

  private
    def set_contact
      @contact = Contact.find(params[:contact_id])
    end

    def address_params
      address_params = DeserializableAddress.call(params[:data].as_json)

      if address_params.empty?
        raise ActionController::ParameterMissing.exception(:address)
      else
        return address_params
      end
    end
end
