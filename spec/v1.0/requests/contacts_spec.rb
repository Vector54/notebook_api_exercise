require 'rails_helper'
 

RSpec.describe "/contacts", type: :request do
  before(:each) do
    @kind = Kind.create!(description: "Comercial")
  end

  let(:valid_attributes) {
    {
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
    }
  }

  let(:valid_kind_relation) {
    {
      kind: {
				data: {
					type: "kinds",
					id: @kind.id
				}
			}
    }
  }

  let(:invalid_attributes) {
    {name: ""}
  }

  let(:invalid_kind_relation) {
    {
      kind: {
				data: {
					type: "kinds",
					id: ""
				}
			}
    }
  }

  let(:header) {
    { 
      "Accept" => "application/vnd.api+json",
      "Api-Version" => "1.0" 
    }
  }

  let(:subdomain) { "http://v1.meusite.local:2002" }

  describe "GET /index" do
    it "renders a successful response" do
      30.times do
        Contact.create! valid_attributes.merge({kind_id: @kind.id})
      end

      get "#{subdomain}/contacts?version=1.0", headers: header

      expect(response).to be_successful
      expect(response.body).to include "\"id\":\"30\""
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      contact = Contact.create! valid_attributes.merge({kind_id: @kind.id})

      get "#{subdomain}/contacts/#{contact.id}?version=1.0", headers: header

      expect(response).to be_successful
      expect(response.body).to include "684864490"
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Contact" do
        post "#{subdomain}/contacts?version=1.0", params: {
          data: {
            type: "contacts",
            attributes: valid_attributes, 
            relationships: valid_kind_relation
          }
        }, 
        headers: header

        expect(response.status).to eq 201
        expect(response.body).to include "Jailson"
        expect(Contact.count).to eq 1
      end
    end

    context "with invalid parameters" do
      it "does not create a new Contact" do
        post "#{subdomain}/contacts?version=1.0", params: {
          data: {
            type: "contacts",
            attributes: invalid_attributes, 
            relationships: invalid_kind_relation
          }
        }, 
        headers: header

        expect(response.status).to eq 422
        expect(response.body).not_to include "Jailson"
        expect(Contact.count).to eq 0
      end
    end
  end

  describe "PATCH /update" do
    before(:each) do
      @kind2 = Kind.create!(description: "Conhecido")
    end

    context "with valid parameters" do
      let(:new_attributes) {
        {
          name: "Jaqueline",
          email: "jaque@line.com",
          phones_attributes: [
            {number: "4444444"}
          ],
          address_attributes: {
            street: "SpecificStreet",
          },
        }
      }

      let(:new_kind_relation) {
        {
          kind: {
            data: {
              type: "kinds",
              id: @kind2.id
            }
          }
        }
      }

      it "updates the requested contact" do
        contact = Contact.create! valid_attributes.merge({kind_id: @kind.id})
        patch "#{subdomain}/contacts/#{contact.id}?version=1.0", params: {
          data: {
            type: "contacts",
            attributes: new_attributes,
            relationships: new_kind_relation
          }
        }, 
        headers: header

        contact.reload

        expect(response.status).to eq 200
        expect(response.body).not_to include "Jailson"
        expect(response.body).to include "Jaqueline"
      end
    end

    context "with invalid parameters" do
      it "does not update the requested contact" do
        contact = Contact.create! valid_attributes.merge({kind_id: @kind.id})

        patch "#{subdomain}/contacts/#{contact.id}?version=1.0", params: {
          data: {
            type: "contacts",
            attributes: invalid_attributes,
            relationships: invalid_kind_relation
          }
        }, 
        headers: header

        expect(response.status).to eq 422
        expect(Contact.last.name).to eq "Jailson"
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested contact" do
      contact = Contact.create! valid_attributes.merge({kind_id: @kind.id})
      expect {
        delete "#{subdomain}/contacts/#{contact.id}?version=1.0", headers: header
      }.to change(Contact, :count).by(-1)
    end
  end
end
