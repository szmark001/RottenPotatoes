class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    if params[:sort_by].nil? && params[:ratings].nil?  && params[:commit].nil?
      if params[:commit].nil?
        if session[:ratings].nil?
          session[:ratings] = {}
          @all_ratings.each{|x| session[:ratings][x] = 1}
        end
        flash.keep
        redirect_to(:action => :index, :sort_by => session[:sort_by], :ratings => session[:ratings])
      end
    elsif (!params[:sort_by].nil? && params[:ratings].nil?)
      flash.keep
      redirect_to(:action => :index, :sort_by => params[:sort_by], :ratings => session[:ratings])
    end
    if params[:sort_by].nil? && params[:ratings].nil? && !params[:commit].nil?
    redirect_to(:action => :index, :sort_by => session[:sort_by], :ratings => session[:ratings])
    end

    if !params[:sort_by].nil?
      session[:sort_by] = params[:sort_by]
    end
    if !params[:ratings].nil?
      session[:ratings] = params[:ratings]
    end
    @filter = []
    @movies = []

    if !params[:ratings].nil?
      @filter = params[:ratings].keys
      Movie.find(:all, :order => "#{session[:sort_by]}").each{|x| @movies << x if session[:ratings].keys.include?(x.rating)}
    else
      @movies = Movie.find(:all, :order => "#{session[:sort_by]}")
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
