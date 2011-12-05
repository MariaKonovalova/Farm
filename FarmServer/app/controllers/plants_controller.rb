require "builder"
class PlantsController < ApplicationController
  MAX_GROWTH = 5

  # GET /plants
  def index
    begin
      render xml: generate_XMl()
    rescue Exception => exc
      render xml: error(exc)
    end
  end

  # POST /plants
  def create
    begin
      params.delete(:action)
      params.delete(:controller)
      params[:field_id] = Field.find_by_user_id(current_user.id).id

      @plant = Plant.new(params)

      if @plant.save
        doc = Builder::XmlMarkup.new(:target => out_string = "", :indent => 1)
        doc.Plant(@plant.attributes)

        render xml: out_string
      end
    rescue Exception => exc
      render xml: error(exc)
    end
  end

  #Вырастить все растения на 1 стадию
  #GET /plants/growth_all
  def growth_all
    begin
      update_count = 0
      field_id = Field.find_by_user_id(current_user.id).id
      plants = Plant.find_all_by_field_id(field_id)
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
    rescue Exception => exc
      render xml: error(exc)
    end
  end

  # DELETE /plants/1
  def destroy
    begin
      @plant = Plant.find(params[:id])
      @plant.destroy
      render xml: ok('Plant deleted successfully')
    rescue Exception => exc
      render xml: error(exc)
    end
  end

  def generate_XMl()
    begin
      field = Field.select("zero_x, zero_y, size_x, size_y").find_by_user_id(current_user.id)
      field_id = Field.find_by_user_id(current_user.id)
      plants = Plant.find_all_by_field_id(field_id)
      doc = Builder::XmlMarkup.new(:target => out_string = "", :indent => 1)
      doc.Field(field.attributes){
        plants.each{ |plant|
          doc.Plant(plant.attributes)
        }
      }
      return out_string
    rescue Exception => exc
      raise(exc)
    end
  end
end
