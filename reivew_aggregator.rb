require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"
require "sinatra/content_for"
require "yelp"

configure do
  enable :sessions
  set :session_secret, "W_3xPj@t^^q{xV!c"
  set :erb, :escape_html => true
end

helpers do

end

before do
  # is the 'client' var available in every path?
  client = Yelp::Client.new({ consumer_key: 'jMzBov2lmUMSKPWCvuDxjw',
                            consumer_secret: 'WDyvycywcvFMdjO1oQBZPcprP28',
                            token: 'tgfUS0CU3gJ3hYCJJ4TpskANIGO3gEvR',
                            token_secret: 'agROOLTDm0nRNrmGpUnpnDnJ8hw'
                            })
  
  # use session[:response] to determine whether there are results or not to render?
  session[:response] = nil
end

# render the main search page
get "/" do
  erb :layout
end

# perform API call & return results of search
post "/search" do
  @term = params[:term]
  @location = params[:location]

  response_data = client.search(@location, { term: @term })
  @results = response_data.businesses

  redirect "/"
end

# render html of one review page of business clicked on in list of businesses
get "/:biz_name/:location" do
  @biz_name = params[:biz_name]
  @location = params[:location]
  
  @response = client.search(@location, { term: @biz_name })
  erb :reviews
end
