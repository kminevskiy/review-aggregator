require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"
require "sinatra/content_for"
require "yelp"
require "yaml"

def load_creds(key)
  creds = YAML.load_file("yelp_creds.yml")
  creds[key]
end

configure do
  @@result = nil
  enable :sessions
  set :session_secret, 'W_3xPj@t^^q{xV!'
  set :erb, :escape_html => true
end

helpers do
end

before do
  # is the 'client' var available in every path?
  @client = Yelp::Client.new({ consumer_key: load_creds("CONSUMER_KEY"),
                            consumer_secret: load_creds("CONSUMER_SECRET"),
                            token: load_creds("TOKEN"),
                            token_secret: load_creds("TOKEN_SECRET")
                            })

  # use session[:response] to determine whether there are results or not to render?
end

# render the main search page
get "/" do
  erb :layout
end

# perform API call & return results of search
post "/search" do
  @term = params[:term]
  @location = params[:location]

  if @term == "" || @location == ""
    redirect "/"
  end

  response_data = @client.search(@location, { term: @term })
  @@result = response_data.businesses

  redirect "/"
end

# render html of one review page of business clicked on in list of businesses
get "/:biz_id/:location" do
  @biz_id = params[:biz_id]
  @location = params[:location]
# @response is a some sort of internal Rails / Sinatra variable and things get hairy when you try to use it as a regular name for a variable. DON'T DO THAT!
  @something_else_but_not_response = client.business(@biz_id)
  erb :reviews
end
