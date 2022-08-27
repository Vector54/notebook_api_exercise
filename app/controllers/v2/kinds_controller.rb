class KindsController < ApplicationController
  # TOKEN = "secret123"
  # http_basic_authenticate_with name: "Victor", password: "secret"
  # before_action :authenticate, except: [ :index ]

  before_action :authenticate_user!, except: %i[ index ]
  before_action :set_kind, only: %i[ show update destroy ]

  # GET /kinds
  def index
    @kinds = Kind.all

    render jsonapi: @kinds 
  end

  # GET /kinds/1
  def show
    render jsonapi: @kind
  end

  # POST /kinds
  def create
    @kind = Kind.new(kind_params)

    if @kind.save
      render jsonapi: @kind, status: :created, location: @kind
    else
      render jsonapi_errors: @kind.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /kinds/1
  def update
    if @kind.update(kind_params)
      render jsonapi: @kind
    else
      render jsonapi_errors: @kind.errors, status: :unprocessable_entity
    end
  end

  # DELETE /kinds/1
  def destroy
    @kind.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kind
      kind_id = params[:contact_id] ? Contact.find(params[:contact_id]).kind_id : params[:id]
      @kind = Kind.find(kind_id)
    end

    # Only allow a list of trusted parameters through.
    def kind_params
      ActionController::Parameters.new(deserialized).permit(
        :description
      )
    end

    # Deserializes incoming json.
    def deserialized
      deserialized = DeserializableKind.call(params[:data].as_json)
    end

    # # Auntenticaçõ.
    # def authenticate
    #   authenticate_or_request_with_http_token do |token, options|
    #     # Compare the tokens in a time-constant manner, to mitigate
    #     # timing attacks.
    #     # ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
    #     hmac_secret = 'my$ecretK3y'
    #     JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }
    #   end
    # end
end
