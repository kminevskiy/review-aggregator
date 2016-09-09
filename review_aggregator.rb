require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"
require "sinatra/content_for"
require "yelp"
require "yaml"
require 'json'

configure do
  set :erb, :escape_html => true

  set :credentials, YAML.load_file("yelp_creds.yml")
  set :client, Yelp::Client.new({ consumer_key: settings.credentials["CONSUMER_KEY"],
                            consumer_secret: settings.credentials["CONSUMER_SECRET"],
                            token: settings.credentials["TOKEN"],
                            token_secret: settings.credentials["TOKEN_SECRET"]
                            })
end

helpers do; end

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

  response_data = settings.client.search(location, { term: term })
  @results = response_data.businesses

  erb :index
end

# TODO render html of one review page of business clicked on in list of businesses
get "/view/:biz_id/obj.json" do
  content_type :json
  biz_id = params[:biz_id]
  returned_business = settings.client.business(biz_id).business
  business_name = returned_business.name
  business_phone = returned_business.display_phone
  business_address = returned_business.location.display_address.join(", ")
  business_reviews_count = returned_business.review_count
  {"business_name": business_name, "business_phone": business_phone, "business_address": business_address, "business_reviews_count": business_reviews_count}.to_json
end
