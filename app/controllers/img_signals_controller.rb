class ImgSignalsController < ApplicationController
  before_action :set_img_signal, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /img_signals
  # GET /img_signals.json
  def index
    @files = Dir.glob("public/*.png")
  end

  # GET /img_signals/1
  # GET /img_signals/1.json
  def show
  end

  # GET /img_signals/new
  def new
    @img_signal = ImgSignal.new
  end

  # GET /img_signals/1/edit
  def edit
  end

  # POST /img_signals
  # POST /img_signals.json
  def create
    @img_signal = ImgSignal.new(img_signal_params)
    @img_signal.file.attach(params[:file])
    @img_signal.save

    p '#'*200
    system("python3 script.py #{@img_signal.file_on_disk}")

    respond_to do |format|
        format.html { redirect_to @img_signal, notice: 'Img signal was successfully created.' }
    end
  end

  # PATCH/PUT /img_signals/1
  # PATCH/PUT /img_signals/1.json
  def update
    respond_to do |format|
      if @img_signal.update(img_signal_params)
        format.html { redirect_to @img_signal, notice: 'Img signal was successfully updated.' }
        format.json { render :show, status: :ok, location: @img_signal }
      else
        format.html { render :edit }
        format.json { render json: @img_signal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /img_signals/1
  # DELETE /img_signals/1.json
  def destroy
    @img_signal.destroy
    respond_to do |format|
      format.html { redirect_to img_signals_url, notice: 'Img signal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_img_signal
      @img_signal = ImgSignal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def img_signal_params
      params.permit(:file)
    end
end
