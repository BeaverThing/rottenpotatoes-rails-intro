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
    
    @redirect = false
    
    if (params[:ratings] == nil && session[:ratings] == nil)
      @rating_list  = @all_ratings
      session[:ratings] = {"G"=>"1", "PG"=>"1", "PG-13"=>"1", "R"=>"1", "NC-17"=>"1"}
    elsif (params[:ratings] == nil)
      @rating_list = session[:ratings].keys
      @redirect = true
      #redirect_to movies_path(:ratings => session[:ratings])   # Extract this redirect
    elsif (params[:ratings] != session[:ratings])
      @rating_list = params[:ratings].keys
      session[:ratings] = params[:ratings]
    else
      @rating_list = params[:ratings].keys
    end
    
    if (params[:sort] != nil && session[:sort] != params[:sort])
      session[:sort] = params[:sort]
    elsif(params[:sort] == nil && session[:sort] != nil)
      @redirect = true #redirect from alph
    end
    
    if(@redirect)
      flash.keep
      redirect_to movies_path(:ratings => session[:ratings], :sort => session[:sort])
    end
    
    
    @movies =  Movie.all
    @rating_filter = @movies.select {|hash_el| @rating_list.include? hash_el[:rating]}

    if params[:sort] == 'Alph'
      @movies = @rating_filter.sort_by{|hsh| hsh[:title]} #Movie.all.order(:title)
    elsif params[:sort] == 'Date'
      @movies = @rating_filter.sort_by{|hsh| hsh[:date]}
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
