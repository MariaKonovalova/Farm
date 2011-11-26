class GrowthsController < ApplicationController
  # GET /growths
  # GET /growths.json
  def index
    @growths = Growth.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @growths }
    end
  end

  # GET /growths/1
  # GET /growths/1.json
  def show
    @growth = Growth.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @growth }
    end
  end

  # GET /growths/new
  # GET /growths/new.json
  def new
    @growth = Growth.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @growth }
    end
  end

  # GET /growths/1/edit
  def edit
    @growth = Growth.find(params[:id])
  end

  # POST /growths
  # POST /growths.json
  def create
    @growth = Growth.new(params[:growth])

    respond_to do |format|
      if @growth.save
        format.html { redirect_to @growth, notice: 'Growth was successfully created.' }
        format.json { render json: @growth, status: :created, location: @growth }
      else
        format.html { render action: "new" }
        format.json { render json: @growth.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /growths/1
  # PUT /growths/1.json
  def update
    @growth = Growth.find(params[:id])

    respond_to do |format|
      if @growth.update_attributes(params[:growth])
        format.html { redirect_to @growth, notice: 'Growth was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @growth.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /growths/1
  # DELETE /growths/1.json
  def destroy
    @growth = Growth.find(params[:id])
    @growth.destroy

    respond_to do |format|
      format.html { redirect_to growths_url }
      format.json { head :ok }
    end
  end
end
