require 'rails_helper'


RSpec.describe "/kinds", type: :request do

  let(:valid_attributes) {
    {description: 'Comercial'}
  }

  let(:invalid_attributes) {
    {not_description: "Carletina"}
  }

  describe "GET /index" do
    it "renders a successful response" do
      Kind.create! valid_attributes

      get kinds_url, headers: { "ACCEPT" => "application/vnd.api+json" }

      expect(response).to be_successful
      expect(response.body).to include "Comercial"
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      kind = Kind.create! valid_attributes

      get kinds_url(kind), headers: { "ACCEPT" => "application/vnd.api+json" }

      expect(response).to be_successful
      expect(response.body).to include "Comercial"
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Kind" do
        post kinds_url, params: { data: {type: "kinds", attributes: valid_attributes} },
                        headers: { "ACCEPT" => "application/vnd.api+json" }

        expect(response.status).to eq 201
        expect(response.body).to include "Comercial"
        expect(Kind.count).to eq 1
      end
    end

    xcontext "with invalid parameters" do
      it "does not create a new Kind" do
        post kinds_url, params: { data: {type: "kinds", attributes: invalid_attributes} },
                        headers: { "ACCEPT" => "application/vnd.api+json" }

        expect(response.status).not_to eq 201
        expect(response.body).not_to include "Comercial"
        expect(Kind.count).not_to eq 1
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {description: 'Conhecido'}
      }

      it "updates the requested kind" do
        kind = Kind.create! valid_attributes
        patch "/kinds/#{kind.id}", params: { data: {type: "kinds", attributes: new_attributes} },
                                    headers: { "ACCEPT" => "application/vnd.api+json" }
        kind.reload
        
        expect(response.status).to eq 200
        expect(response.body).not_to include "Comercial"
        expect(response.body).to include "Conhecido"
      end
    end

    xcontext "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        contact = Contact.create! valid_attributes
        patch contact_url(contact), params: { contact: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested kind" do
      kind = Kind.create! valid_attributes
      expect {
        delete kind_url(kind), headers: { "ACCEPT" => "application/vnd.api+json" }
      }.to change(Kind, :count).by(-1)
    end
  end
end
