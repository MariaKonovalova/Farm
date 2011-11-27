class GrowthStagesController < ApplicationController
  # GET /growth_stages
  # GET /growth_stages.json
  def index
    @growth_stages = GrowthStage.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @growth_stages }
    end
  end

  # GET /growth_stages/1
  # GET /growth_stages/1.json
  def show
    @growth_stage = GrowthStage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @growth_stage }
    end
  end

  # GET /growth_stages/new
  # GET /growth_stages/new.json
  def new
    @growth_stage = GrowthStage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @growth_stage }
    end
  end

  # GET /growth_stages/1/edit
  def edit
    @growth_stage = GrowthStage.find(params[:id])
  end

  # POST /growth_stages
  # POST /growth_stages.json
  def create
    @growth_stage = GrowthStage.new(params[:growth_stage])

    respond_to do |format|
      if @growth_stage.save
        format.html { redirect_to @growth_stage, notice: 'Growth stage was successfully created.' }
        format.json { render json: @growth_stage, status: :created, location: @growth_stage }
      else
        format.html { render action: "new" }
        format.json { render json: @growth_stage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /growth_stages/1
  # PUT /growth_stages/1.json
  def update
    @growth_stage = GrowthStage.find(params[:id])

    respond_to do |format|
      if @growth_stage.update_attributes(params[:growth_stage])
        format.html { redirect_to @growth_stage, notice: 'Growth stage was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @growth_stage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /growth_stages/1
  # DELETE /growth_stages/1.json
  def destroy
    @growth_stage = GrowthStage.find(params[:id])
    @growth_stage.destroy

    respond_to do |format|
      format.html { redirect_to growth_stages_url }
      format.json { head :ok }
    end
  end
end
