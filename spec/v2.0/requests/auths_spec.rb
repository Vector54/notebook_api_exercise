require 'rails_helper'

RSpec.describe "Auths", type: :request do

  let(:valid_attributes_token) {
    {name: 'Josa Pereira'}
  }

  let(:valid_attributes_user) {
    {
      email: 'josa@pereira.com',
      password: '12345678',
      password_confirmation: '12345678'
    }
  }

  let(:invalid_attributes_user) {
    {
      email: 'josa@pereira.com',
      password: '1235678',
      password_confirmation: '12345678'
    }
  }

  let(:header) {
    { 
      "ACCEPT" => "application/vnd.api+json", 
    }
  }

  context "Token creation" do
    describe "POST /create" do
      context "with valid parameters" do
        it "creates a new Token" do
          post auths_url, params: valid_attributes_token, headers: header

          expect(response.status).to eq 200
          expect(response.body).to include "\"token\":"
        end
      end

      context "with invalid parameters" do
        it "does not create a new Token" do
          post kinds_url, headers: header

          expect(response.status).not_to eq 200
          expect(response.body).not_to include "\"token\":"
        end
      end
    end
  end

  context "User creation and login" do
    describe "POST /auth" do
      context "with valid parameters" do
        it "creates a new User" do
          post "http://www.example.com/auth", params: valid_attributes_user, headers: header

          expect(response.status).to eq 200
          expect(response.body).to include "\"email\":\"josa@pereira.com\""
        end
      end

      context "with invalid parameters" do
        it "does not create a new Token" do
          post "http://www.example.com/auth", params: invalid_attributes_user, headers: header

          expect(response.status).to eq 422
          expect(response.body).to include "Confirme sua senha não é igual a Senha"
        end
      end
    end
  end
end
