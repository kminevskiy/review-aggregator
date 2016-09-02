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

before do; end

get "/" do
  
end

post "/search" do
  
end
