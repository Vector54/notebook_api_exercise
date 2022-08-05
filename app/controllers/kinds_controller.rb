class KindsController < ApplicationController
  before_action :set_kind, only: %i[ show update destroy ]
  deserializable_resource :kind, only: [:create, :update]

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
      @kind = Kind.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def kind_params
      params.require(:kind).permit(:description)
    end
end
