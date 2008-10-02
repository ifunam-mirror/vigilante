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
  
  def send_movie
    video = Video.find(params[:id])
    send_file video.path, :type => 'video/x-msvideo', :disposition => 'inline' 
  end
  
  def generate_image
    video = Video.find(params[:id])
    send_file( video.thumbnail, :type => 'image/jpeg', :dispostion => 'inline',
      :filename => "#{video.filename}.jpg" )
  end
  
end
