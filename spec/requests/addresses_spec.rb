require 'rails_helper'

RSpec.describe "Addresses", type: :request do
  before(:each) do
    @kind = Kind.create!(description: "Some")
    @contact = Contact.create!(
      name: "Jailson",
      email: "jail@son.com",
      birthdate: "1959-01-18T00:00:00-03:00",
      phones_attributes: [
        {number: "684864490"},
        {number: "9849486648"}
      ],
      kind_id: @kind.id
    )
  end

  let(:header) {
    { "ACCEPT" => "application/vnd.api+json" }
  }

  describe "GET /contacts/1/address" do
    it "returns http success" do
      @contact.address = Address.create(street: "somewhere", city: "somehow")

      get "/contacts/#{@contact.id}/address", headers: header

      expect(response).to have_http_status(:success)
      expect(response.body).to include "somewhere"
    end 
  end

  describe "POST /contacts/1/address" do
    it "creates a new Address" do
      post "/contacts/#{@contact.id}/address", params: {
        data: {
          type: "addresses",
          attributes: {
            street: "Anotherstreet",
            city: "Someothercity"
          }
        }
      },
      headers: header

      expect(response.status).to eq 201
      expect(response.body).to include "Anotherstreet"
      expect(response.body).to include "Someothercity"
      expect(Address.count).to eq 1
    end 

    it "does not create a new Address" do
      post "/contacts/#{@contact.id}/address", params: {
        data: {
          type: "addresses",
          attributes: {
            street: "",
            city: "Someothercity"
          }
        }
      },
      headers: header

      expect(response.status).to eq 422
      expect(response.body).to include "Street não pode ficar em branco"
      expect(Address.count).to eq 0
    end 
  end

  describe "PATCH /contacts/1/address" do
    it "updates an existing Address" do
      @contact.address = Address.create(street: "somewhere", city: "somehow")
      patch "/contacts/#{@contact.id}/address", params: {
        data: {
          type: "addresses",
          attributes: {
            street: "Anotherstreet",
            city: "Someothercity"
          }
        }
      },
      headers: header

      expect(response.status).to eq 200
      expect(response.body).to include "Anotherstreet"
      expect(response.body).to include "Someothercity"
      expect(Address.count).to eq 1
    end

    it "does not update an existing Address" do
      @contact.address = Address.create(street: "somewhere", city: "somehow")
      patch "/contacts/#{@contact.id}/address", params: {
        data: {
          type: "addresses",
          attributes: {
            street: "",
            city: "Someothercity"
          }
        }
      },
      headers: header

      expect(response.status).to eq 422
      expect(response.body).to include "Street não pode ficar em branco"
      expect(@contact.address.street).to eq "somewhere"
    end 
  end
end
