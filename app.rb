require 'sinatra'
require 'sinatra/activerecord'
require './models.rb'
require 'sinatra/reloader'

set :database, "sqlite3:bookface.sqlite3"

enable :sessions

configure(:development){set :database, "sqlite3:bookface.sqlite3"}

get '/' do
  erb :sign_up
end

# get '/signup' do
#   erb :sign_up
# end

post '/signup' do
  User.create :username => params[:username], :email => params[:email], :password => params[:password]

  redirect '/profile'
  #add this as a flash notice later
  # "You've Signed Up!"
end

post '/sign_in' do
  redirect '/home'
end

get '/home' do
  "Welcome back your feed!"
end

get '/profile' do
  erb :profile
end

get '/signout' do

  session[:user_id] = nil
  flash[:notice] = "Signed Out Successfully. Come back soon!"
  redirect '/'
end
