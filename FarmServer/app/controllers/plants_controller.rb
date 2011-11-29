require "builder"
class PlantsController < ApplicationController

  MAX_GROWTH = 5

  # GET /plants
=begin
  def index
    @plants = Plant.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plants }
    end
  end
=end

  # GET /plants/1
  # GET /plants/1.json
=begin
  def show
    @plant = Plant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @plant }
    end
  end
=end

  # GET /plants/new
  # GET /plants/new.json
=begin
  def new
    @plant = Plant.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @plant }
    end
  end
=end

  # GET /plants/1/edit
=begin
  def edit
    @plant = Plant.find(params[:id])
  end
=end

  # POST /plants
  def create
    params[:field_id] = session[:field_id]
    params.delete(:action)
    params.delete(:controller)
    @plant = Plant.new(params)

    if @plant.save
      #render :template => 'plants/country.xml.builder', :layout => false
      #render xml: @plant, status: :created, location: @plant
      render xml: generate_XMl()
    else
      #рендеринг ошибки
    end
  end

  #Вырастить все растения на 1 стадию
  #GET /plants/growth_all
  def growth_all
    update_count = 0
    plants = Plant.find_all_by_field_id(session[:field_id])
    plants.each {|plant|
       if plant[:growth_stage_id] < MAX_GROWTH
         if plant.update_attributes({:growth_stage_id => plant[:growth_stage_id] + 1})
           update_count += 1
         end
       else
         update_count += 1
       end
    }

    if (update_count == plants.length)
      render xml: generate_XMl()
    end
  end

  # PUT /plants/1
  # PUT /plants/1.json
=begin
  def update
    update_count = 0
    @plants = Plant.find_all_by_field_id(1)
    @plants.each {|plant|
       if plant[:growth_stage_id] < MAX_GROWTH
         if plant.update_attributes({:growth_stage_id => plant[:growth_stage_id] + 1})
           inc(update_count)
         end
       end
    }

    if (update_count = @plants.length)

    end
=end
=begin
    @plant = Plant.find(params[:id])

    respond_to do |format|
      if @plant.update_attributes(params[:plant])
        format.html { redirect_to @plant, notice: 'Plant was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @plant.errors, status: :unprocessable_entity }
      end
    end
  end
=end

  # DELETE /plants/1
  def destroy
    @plant = Plant.find(params[:id])
    @plant.destroy

    render xml: generate_XMl()
=begin
    respond_to do |format|
      format.html { redirect_to plants_url }
      format.json { head :ok }
    end
=end
  end

  def generate_XMl()
    field = Field.select("zero_x, zero_y, size_x, size_y").find(session[:field_id])
    plants = Plant.select("et.name, plants.id, plants.x, plants.y, g.stage").joins("LEFT JOIN element_types AS et
      ON et.id = plants.element_type_id").joins("LEFT JOIN growth_stages AS g
      ON g.id = plants.growth_stage_id").find_all_by_field_id(session[:field_id])
    doc = Builder::XmlMarkup.new(:target => out_string = "", :indent => 1)
    doc.Field(field.attributes){
      plants.each{ |plant|
         doc.Plant(plant.attributes)
      }
    }
    return out_string
  end
end
