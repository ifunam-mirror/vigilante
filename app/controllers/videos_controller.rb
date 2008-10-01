class VideosController < ApplicationController
  # GET /videos
  # GET /videos.xml
  def index
    conditions = {}
    conditions[:camera_id] = params[:camera_id]
    
    @videos = Video.search_with_paginate(conditions, params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @videos }
    end
  end
  
  def search
    session[:query] = params[:search] if params[:search]
    @videos = Video.search_with_paginate(session[:query], params[:page])
    respond_to do |format|
      format.html { render :action => :index }
    end
  end

  # GET /videos/1
  # GET /videos/1.xml
  def show
    @video = Video.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @video }
    end
  end

  # Actions that will not be used (fold)
  
  # # GET /videos/new
  # # GET /videos/new.xml
  # def new
  #   @video = Video.new
  # 
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.xml  { render :xml => @video }
  #   end
  # end
  # 
  # # GET /videos/1/edit
  # def edit
  #   @video = Video.find(params[:id])
  # end
  # 
  # # POST /videos
  # # POST /videos.xml
  # def create
  #   @video = Video.new(params[:video])
  # 
  #   respond_to do |format|
  #     if @video.save
  #       flash[:notice] = 'Video was successfully created.'
  #       format.html { redirect_to(@video) }
  #       format.xml  { render :xml => @video, :status => :created, :location => @video }
  #     else
  #       format.html { render :action => "new" }
  #       format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # PUT /videos/1
  # # PUT /videos/1.xml
  # def update
  #   @video = Video.find(params[:id])
  # 
  #   respond_to do |format|
  #     if @video.update_attributes(params[:video])
  #       flash[:notice] = 'Video was successfully updated.'
  #       format.html { redirect_to(@video) }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # DELETE /videos/1
  # # DELETE /videos/1.xml
  # def destroy
  #   @video = Video.find(params[:id])
  #   @video.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(videos_url) }
  #     format.xml  { head :ok }
  #   end
  # end
  # (end)
  
  def send_movie
    video = Video.find(params[:id])
    send_file video.path, :type => 'video/x-msvideo', :disposition => 'inline' 
  end
  
  def generate_image
    video = Video.find(params[:id])
    send_data( video.thumbnail, :type => 'image/jpg', :dispostion => 'inline',
      :filename => "#{video.filename}.jpg" )
  end
  
end
