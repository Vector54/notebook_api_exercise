require 'rails_helper'

RSpec.describe KindsController, type: :request do
  describe "/POST " do
    it "successfully" do
      headers = { "ACCEPT" => "application/vnd.api+json" }
      post "/kinds", params: { type: "kinds", attributes: {description: "aaaaa"} }, headers: headers
      # debugger
      expect(Kind.count).to eq 1
    end
  end
end