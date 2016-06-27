class CountrySubdivisionsController < ApplicationController
  before_action :set_country_subdivision, only: [:show, :edit, :update, :destroy]

  # GET /country_subdivisions
  # GET /country_subdivisions.json
  def index
    @country_subdivisions = CountrySubdivision.all
  end

  # GET /country_subdivisions/1
  # GET /country_subdivisions/1.json
  def show
  end

  # GET /country_subdivisions/new
  def new
    @country_subdivision = CountrySubdivision.new
  end

  # GET /country_subdivisions/1/edit
  def edit
  end

  # POST /country_subdivisions
  # POST /country_subdivisions.json
  def create
    @country_subdivision = CountrySubdivision.new(country_subdivision_params)

    respond_to do |format|
      if @country_subdivision.save
        format.html { redirect_to @country_subdivision, notice: 'Country subdivision was successfully created.' }
        format.json { render :show, status: :created, location: @country_subdivision }
      else
        format.html { render :new }
        format.json { render json: @country_subdivision.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /country_subdivisions/1
  # PATCH/PUT /country_subdivisions/1.json
  def update
    respond_to do |format|
      if @country_subdivision.update(country_subdivision_params)
        format.html { redirect_to @country_subdivision, notice: 'Country subdivision was successfully updated.' }
        format.json { render :show, status: :ok, location: @country_subdivision }
      else
        format.html { render :edit }
        format.json { render json: @country_subdivision.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /country_subdivisions/1
  # DELETE /country_subdivisions/1.json
  def destroy
    @country_subdivision.destroy
    respond_to do |format|
      format.html { redirect_to country_subdivisions_url, notice: 'Country subdivision was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_country_subdivision
      @country_subdivision = CountrySubdivision.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def country_subdivision_params
      params.require(:country_subdivision).permit(:name, :position, :country_id)
    end
end
