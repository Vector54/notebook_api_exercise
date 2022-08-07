class ContactsController < ApplicationController
  before_action :set_contact, only: %i[ show update destroy ]

  # GET /contacts
  def index
    @contacts = Contact.all

    render jsonapi: @contacts
  end

  # GET /contacts/1
  def show
    render jsonapi: @contact, include: [:kind, :phones, :address], 
    fields: { 
      phones: [:number], addresses: [:street, :city], kinds: [:description] 
    }
  end

  # POST /contacts
  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      render jsonapi: @contact, include: [:kind, :phones, :address], status: :created, location: @contact
    else
      render jsonapi_errors: @contact.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contacts/1
  def update
    if @contact.update(contact_params)
      render jsonapi: @contact, include: [:kind, :phones, :address]
    else
      render jsonapi_errors: @contact.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contact_params
      deserializable_params = params[:data].as_json
      DeserializableContact.call(deserializable_params)
    end
end
