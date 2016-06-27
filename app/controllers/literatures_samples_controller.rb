class LiteraturesSamplesController < ApplicationController
  before_action :set_literatures_sample, only: [:show, :edit, :update, :destroy]

  # GET /literatures_samples
  # GET /literatures_samples.json
  def index
    @literatures_samples = LiteraturesSample.all
  end

  # GET /literatures_samples/1
  # GET /literatures_samples/1.json
  def show
  end

  # GET /literatures_samples/new
  def new
    @literatures_sample = LiteraturesSample.new
  end

  # GET /literatures_samples/1/edit
  def edit
  end

  # POST /literatures_samples
  # POST /literatures_samples.json
  def create
    @literatures_sample = LiteraturesSample.new(literatures_sample_params)

    respond_to do |format|
      if @literatures_sample.save
        format.html { redirect_to @literatures_sample, notice: 'Literatures sample was successfully created.' }
        format.json { render :show, status: :created, location: @literatures_sample }
      else
        format.html { render :new }
        format.json { render json: @literatures_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /literatures_samples/1
  # PATCH/PUT /literatures_samples/1.json
  def update
    respond_to do |format|
      if @literatures_sample.update(literatures_sample_params)
        format.html { redirect_to @literatures_sample, notice: 'Literatures sample was successfully updated.' }
        format.json { render :show, status: :ok, location: @literatures_sample }
      else
        format.html { render :edit }
        format.json { render json: @literatures_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /literatures_samples/1
  # DELETE /literatures_samples/1.json
  def destroy
    @literatures_sample.destroy
    respond_to do |format|
      format.html { redirect_to literatures_samples_url, notice: 'Literatures sample was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_literatures_sample
      @literatures_sample = LiteraturesSample.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def literatures_sample_params
      params.require(:literatures_sample).permit(:literature_id, :sample_id, :pages)
    end
end
