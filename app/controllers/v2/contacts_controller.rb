module V2
  class ContactsController < ApplicationController
    before_action :set_contact, only: %i[ show update destroy ]

    # GET /contacts
    def index
      page_number = params[:page].try(:[], :number)
      page_size = params[:page].try(:[], :size)

      @contacts = Contact.all.page(page_number).per(page_size)

      render jsonapi: @contacts, links: JsonPaginator.call(@contacts, v2_contacts_url)
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
        render jsonapi: @contact, include: [:kind, :phones, :address], status: :created, location: "http://localhost:2002/contacts/#{@contact.id}?version=2.0"
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
      Phone.where(contact: @contact).each {|p| p.destroy}
      Address.where(contact: @contact).each {|a| a.destroy}
      @contact.destroy
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
      # Use callbacks to share common setup or constraints between actions.
      def set_contact
        @contact = Contact.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def contact_params
        ActionController::Parameters.new(deserialized).permit(
          :name, :email, :birthdate, :kind_id, 
          phones_attributes: [:number, :id],
          address_attributes: [:street, :city, :id] 
        )
      end

      # Deserializes incoming json.
      def deserialized
        deserialized = DeserializableContact.call(params[:data].as_json)
      end
  end
end