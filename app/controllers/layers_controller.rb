class LayersController < ApplicationController
  # GET /layers
  # GET /layers.json
  def index
    @layers = @current_account.layers.all
    respond_with(@layers)
  end

  def explore
    render :layout =>  "explore"
  end 
  # GET /layers/1
  # GET /layers/1.json
  def show
    @layer = @current_account.layers.find(params[:id])

    respond_with(@layer)
  end
end