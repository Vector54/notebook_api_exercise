require 'rails_helper'

RSpec.describe "Phones", type: :request do
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
      address_attributes: {
        street: "Somestreet",
        city: "Sometown"
      },
      kind_id: @kind.id
    )
  end

  let(:header) {
    { 
      "Accept" => "application/vnd.api+json",
      "Api-Version" => "1.0" 
    }
  }

  describe "GET /contacts/1/phones" do
    it "returns http success" do
      get "/contacts/#{@contact.id}/phones", headers: header

      expect(response).to have_http_status(:success)
      expect(response.body).to include "684864490"
      expect(response.body).to include "9849486648"
    end 
  end

  describe "POST /contacts/1/phone" do
    it "creates a new Phone" do
      post "/contacts/#{@contact.id}/phone", params: {
        data: {
          type: "phones",
          attributes: {
            number: "123456789"
          }
        }
      },
      headers: header

      expect(response.status).to eq 201
      expect(response.body).to include "123456789"
      expect(Phone.count).to eq 3
    end 

    it "does not create a new Phone" do
      post "/contacts/#{@contact.id}/phone", params: {
        data: {
          type: "phones",
          attributes: {
            number: ""
          }
        }
      },
      headers: header

      expect(response.status).to eq 422
      expect(response.body).to include "Number não pode ficar em branco"
      expect(Phone.count).to eq 2
    end 
  end

  describe "PATCH /contacts/1/phone" do
    it "updates an existing Phone" do
      patch "/contacts/#{@contact.id}/phone", params: {
        data: {
          type: "phones",
          id: @contact.phones.first.id,
          attributes: {
            number: "123456789"
          }
        }
      },
      headers: header

      expect(response.status).to eq 200
      expect(response.body).to include "123456789"
      expect(Phone.count).to eq 2
    end 

    it "does not update an existing Phone" do
      patch "/contacts/#{@contact.id}/phone", params: {
        data: {
          type: "phones",
          id: @contact.phones.first.id,
          attributes: {
            number: ""
          }
        }
      },
      headers: header

      expect(response.status).to eq 422
      expect(response.body).to include "Number não pode ficar em branco"
      expect(Phone.count).to eq 2
    end 
  end

  describe "DELETE /contacts/1/phones/1" do
    it "destroys a phone from a contact" do
      delete "/contacts/#{@contact.id}/phones/#{@contact.phones.first.id}",
      headers: header

      expect(response.status).to eq 204
      expect(@contact.phones.count).to eq 1
    end
  end
end
