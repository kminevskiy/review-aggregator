require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"
require "sinatra/content_for"
require "yelp"
require "yaml"

configure do
  set :erb, :escape_html => true

  set :credentials, YAML.load_file("yelp_creds.yml")
  set :client, Yelp::Client.new({ consumer_key: settings.credentials["CONSUMER_KEY"],
                            consumer_secret: settings.credentials["CONSUMER_SECRET"],
                            token: settings.credentials["TOKEN"],
                            token_secret: settings.credentials["TOKEN_SECRET"]
                            })
end

helpers do
end

before do
  @result = nil
end

# render the main search page
get '/' do
  erb :index
end

# perform API call & return results of search
post "/search" do
  term = params[:term]
  location = params[:location]

  redirect back if term == "" || location == ""

  response_data = settings.client.search(location, { term: term })
  @result = response_data.businesses

  redirect "/"
end

# TODO render html of one review page of business clicked on in list of businesses
get "/:biz_id/:location" do
  @biz_id = params[:biz_id]
  @location = params[:location]

# @response is a some sort of internal Rails / Sinatra variable and things get hairy when you try to use it as a regular name for a variable. DON'T DO THAT!
  @something_else_but_not_response = client.business(@biz_id)

  erb :reviews
end
