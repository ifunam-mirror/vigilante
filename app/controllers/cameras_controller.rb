class CamerasController < ApplicationController
  layout 'cameras_map', :only => [:index, :edit]
  
  # GET /cameras
  # GET /cameras.xml
  def index
    @map = GMap.new("map_div")
    @map.control_init(:large_map => false,:small_zoom => false, :map_type => false)
    @map.center_zoom_init([19.324600, -99.176432],18)
    @map.interface_init(:dragging => false, :double_click_zoom => false)
    @map.set_map_type_init(GMapType::G_HYBRID_MAP)
    
    @cameras = Camera.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cameras }
    end
  end

  # GET /cameras/1
  # GET /cameras/1.xml
  def show
    @camera = Camera.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @camera }
    end
  end

  # GET /cameras/new
  # GET /cameras/new.xml
  def new
    @camera = Camera.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @camera }
    end
  end

  # GET /cameras/1/edit
  def edit
    @camera = Camera.find(params[:id])
    
    @map = GMap.new("map_div")
    @map.control_init(:large_map => false,:small_zoom => false, :map_type => false)
    @map.center_zoom_init([19.324600, -99.176432],18)
    @map.interface_init(:dragging => false, :double_click_zoom => false)
    @map.set_map_type_init(GMapType::G_HYBRID_MAP)
    
    if @camera.lat.nil? || @camera.lat.nil?
      @map.event_init(@map,:click,"addMarker")
    else
      @marker = GMarker.new([@camera.lat.to_f, @camera.lng.to_f], :draggable => true)
      @map.declare_init(@marker, 'marker')
      @map.overlay_init(@marker)
      @map.event_init(@marker, :dragend, "dragMarker")
    end
  end

  # POST /cameras
  # POST /cameras.xml
  def create
    @camera = Camera.new(params[:camera])

    respond_to do |format|
      if @camera.save
        flash[:notice] = 'Camera was successfully created.'
        format.html { redirect_to(@camera) }
        format.xml  { render :xml => @camera, :status => :created, :location => @camera }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @camera.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cameras/1
  # PUT /cameras/1.xml
  def update
    @camera = Camera.find(params[:id])

    respond_to do |format|
      if @camera.update_attributes(params[:camera])
        flash[:notice] = 'Camera was successfully updated.'
        format.html { redirect_to(@camera) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @camera.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cameras/1
  # DELETE /cameras/1.xml
  def destroy
    @camera = Camera.find(params[:id])
    @camera.destroy

    respond_to do |format|
      format.html { redirect_to(cameras_url) }
      format.xml  { head :ok }
    end
  end
  
  def statistic
    
  end
  
end
