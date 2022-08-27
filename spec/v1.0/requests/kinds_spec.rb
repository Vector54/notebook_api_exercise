require 'rails_helper'


RSpec.describe "/kinds", type: :request do

  before (:all) do
    @user = User.create(
      email: "test@user.com",
      password: "12345678"
    )
    post "http://v1.meusite.local:2002/auth/sign_in", params: {
      email: "test@user.com",
      password: "12345678"
    }, headers: { "ACCEPT" => "application/vnd.api+json" }
    @access_token = response.header["access-token"]
    @client = response.header["client"]
    @uid = response.header["uid"]
  end

  let(:valid_attributes) {
    {description: 'Comercial'}
  }

  let(:valid_attributes2) {
    {description: 'Amigo'}
  }

  let(:invalid_attributes) {
    {not_description: "Carletina"}
  }

  let(:subdomain) { "http://v1.meusite.local:2002" }

  let(:header) {
    { 
      "ACCEPT" => "application/vnd.api+json", 
      "access-token" => @access_token,
      "client" => @client,
      "uid" => @uid,
    }
  }

  describe "GET /index" do
    it "renders a successful response" do
      Kind.create! valid_attributes

      get "#{subdomain}/kinds", headers: header

      expect(response).to be_successful
      expect(response.body).to include "Comercial"
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      kind = Kind.create! valid_attributes
      kind2 = Kind.create! valid_attributes2

      get "#{subdomain}/kinds/1", headers: header

      expect(response).to be_successful
      expect(response.body).to include valid_attributes[:description]
      expect(response.body).not_to include valid_attributes2[:description]
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Kind" do
        post kinds_url, params: { data: {type: "kinds", attributes: valid_attributes} },
                        headers: header

        expect(response.status).to eq 201
        expect(response.body).to include "Comercial"
        expect(Kind.count).to eq 1
      end
    end

    xcontext "with invalid parameters" do
      it "does not create a new Kind" do
        post kinds_url, params: { data: {type: "kinds", attributes: invalid_attributes} },
                        headers: header

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
                                    headers: header
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
        delete kind_url(kind), headers: header
      }.to change(Kind, :count).by(-1)
    end
  end
end
