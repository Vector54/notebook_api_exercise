class V1::PhonesController < ApplicationController
  before_action :set_contact

  def destroy
    Phone.find(params[:id]).destroy
  end

  def update
    @phone = Phone.find(deserialized[:id])

    if @phone.update(phone_params)
      render jsonapi: @phone
    else
      render jsonapi_errors: @phone.errors, status: :unprocessable_entity
    end
  end

  def create
    @phone = Phone.new(phone_params.merge({contact: @contact}))

    if @phone.save
      render jsonapi: @phone, status: :created, location: "http://localhost:2002/contacts/#{@contact.id}/phones?version=1.0"
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
      ActionController::Parameters.new(deserialized).permit(
        :number
      )
    end

    def deserialized
      deserialized = DeserializablePhone.call(params[:data].as_json)
    end
end
