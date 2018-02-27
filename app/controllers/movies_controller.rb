class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  
  

  #def index
  #  @movies = Movie.all
  #end

  def index
    
    @all_ratings = Movie.get_ratings
    
    if (params[:ratings] == nil)
      @rating_list  = @all_ratings  
    else
      @rating_list = params[:ratings].keys
    end
    
    @movies = Movie.all
    
    @rating_filter = @movies.select {|hash_el| @rating_list.include? hash_el[:rating]}
    
    if params[:sort] == 'Alph'
      @movies = @rating_filter.order(:title)
    elsif params[:sort] == 'Date'
      @movies = @rating_filter.order(:release_date)
    else
      @movies = @rating_filter
    end
  end
  
  

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
