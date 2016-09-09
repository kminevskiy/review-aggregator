require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"
require "sinatra/content_for"
require "yelp"
require "yaml"
require "google_places"
require "pry"

# NOTE: DO NOT name any instance variables as @response, or they will collide w/
# Sinatra framework

configure do
  set :erb, :escape_html => true

  set :credentials, YAML.load_file("yelp_creds.yml")
  set :yelp_client, Yelp::Client.new({ consumer_key: settings.credentials["CONSUMER_KEY"],
                            consumer_secret: settings.credentials["CONSUMER_SECRET"],
                            token: settings.credentials["TOKEN"],
                            token_secret: settings.credentials["TOKEN_SECRET"]
                            })
  set :google_client, GooglePlaces::Client.new("AIzaSyB-kXUGhXxjSSeWZZ3YQnQRp0P3GMnmats")
end

helpers do
  def calc_google_rating(google_biz)
    ratings = google_biz.reviews.map { |review| review.rating }
    ( ratings.reduce(:+).to_f / ratings.size ).round(1)
  end
end

before do; end

# render the main search page
get "/" do
  erb :index
end

get "/search" do
  redirect "/"
end

# perform API call & return results of search
post "/search" do
  term = params[:term]
  location = params[:location]

  redirect back if term == "" || location == ""

  yelp_response_data = settings.yelp_client.search(location, { term: term })
  @results = yelp_response_data.businesses
  
  erb :index
end

# TODO render html of one review page of business clicked on in list of businesses
get "/view/:biz_id" do
  @biz_id = params[:biz_id]
  @yelp_response = settings.yelp_client.business(@biz_id)
  @google_response = settings.google_client.spots_by_query(@biz_id).first
  # @fb_response = fb api call w/biz_id

  @google_biz = settings.google_client.spot(@google_response.place_id)
  @yelp_biz = @yelp_response.business

  erb :reviews
end
