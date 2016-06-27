class PrmatsController < ApplicationController
  before_action :set_prmat, only: [:show, :edit, :update, :destroy]

  # GET /prmats
  # GET /prmats.json
  def index
    @prmats = Prmat.all
  end

  # GET /prmats/1
  # GET /prmats/1.json
  def show
  end

  # GET /prmats/new
  def new
    @prmat = Prmat.new
  end

  # GET /prmats/1/edit
  def edit
  end

  # POST /prmats
  # POST /prmats.json
  def create
    @prmat = Prmat.new(prmat_params)

    respond_to do |format|
      if @prmat.save
        format.html { redirect_to @prmat, notice: 'Prmat was successfully created.' }
        format.json { render :show, status: :created, location: @prmat }
      else
        format.html { render :new }
        format.json { render json: @prmat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prmats/1
  # PATCH/PUT /prmats/1.json
  def update
    respond_to do |format|
      if @prmat.update(prmat_params)
        format.html { redirect_to @prmat, notice: 'Prmat was successfully updated.' }
        format.json { render :show, status: :ok, location: @prmat }
      else
        format.html { render :edit }
        format.json { render json: @prmat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prmats/1
  # DELETE /prmats/1.json
  def destroy
    @prmat.destroy
    respond_to do |format|
      format.html { redirect_to prmats_url, notice: 'Prmat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prmat
      @prmat = Prmat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prmat_params
      params.require(:prmat).permit(:name, :position)
    end
end
