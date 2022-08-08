class PhonesController < ApplicationController
  before_action :set_contact

  def update
    @phone = Phone.find(params[:id])

    if @phone.update(phone_params)
      render jsonapi: @phone
    else
      render jsonapi_errors: @phone.errors, status: :unprocessable_entity
    end
  end

  def create
    @phone = Phone.new(phone_params.merge({contact: @contact}))

    if @phone.save
      render jsonapi: @phone, status: :created, location: contact_phones_url(@contact.id)
    else
      render jsonapi_errors: @phone.errors, status: :unprocessable_entity
    end
  end

  def index
    @phones = @contact.phones

    render jsonapi: @phones
  end

  private
    def set_contact
      @contact = Contact.find(params[:contact_id])
    end

    def phone_params
      phone_params = DeserializablePhone.call(params[:data].as_json)

      if phone_params.empty?
        raise ActionController::ParameterMissing.exception(:phone)
      else
        return phone_params
      end
    end
end
