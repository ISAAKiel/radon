class DatingMethodsController < ApplicationController
  before_action :set_dating_method, only: [:show, :edit, :update, :destroy]

  # GET /dating_methods
  # GET /dating_methods.json
  def index
    @dating_methods = DatingMethod.all
  end

  # GET /dating_methods/1
  # GET /dating_methods/1.json
  def show
  end

  # GET /dating_methods/new
  def new
    @dating_method = DatingMethod.new
  end

  # GET /dating_methods/1/edit
  def edit
  end

  # POST /dating_methods
  # POST /dating_methods.json
  def create
    @dating_method = DatingMethod.new(dating_method_params)

    respond_to do |format|
      if @dating_method.save
        format.html { redirect_to @dating_method, notice: 'Dating method was successfully created.' }
        format.json { render :show, status: :created, location: @dating_method }
      else
        format.html { render :new }
        format.json { render json: @dating_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dating_methods/1
  # PATCH/PUT /dating_methods/1.json
  def update
    respond_to do |format|
      if @dating_method.update(dating_method_params)
        format.html { redirect_to @dating_method, notice: 'Dating method was successfully updated.' }
        format.json { render :show, status: :ok, location: @dating_method }
      else
        format.html { render :edit }
        format.json { render json: @dating_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dating_methods/1
  # DELETE /dating_methods/1.json
  def destroy
    @dating_method.destroy
    respond_to do |format|
      format.html { redirect_to dating_methods_url, notice: 'Dating method was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dating_method
      @dating_method = DatingMethod.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dating_method_params
      params.require(:dating_method).permit(:name, :position)
    end
end
