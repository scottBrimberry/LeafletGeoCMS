class Backend::ContextsController < Backend::ApplicationController

  def new
    @context = Context.new
    respond_with([:backend, @context])
  end

  def create
    @context = Context.new(params[:context])
    raise params.inspect
    @context.save
    respond_with([:backend, @context])
  end

  def update
    @context = Context.find(params[:id])
    @context.update_attributes(params[:context])
    respond_with([:backend, @context])
  end
end