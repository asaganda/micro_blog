require 'sinatra'
require 'sinatra/activerecord'
require './models.rb'
require 'sinatra/reloader'
require 'rack-flash'

set :database, "sqlite3:bookface.sqlite3"

enable :sessions

use Rack::Flash, sweep: true

configure(:development){set :database, "sqlite3:bookface.sqlite3"}

def current_user
  if session[:user_id]
    User.find session[:user_id]
  end

end


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
  username = params[:username]
  password = params[:password]

  @user = User.where(username: username).first

  if @user.password == password
    session[:user_id] = @user.id
    flash[:notice] = "Welcome #{@user.username}!"
    redirect '/home'
  else
    flash[:notice] = "Wrong login info, please try again"
    redirect '/'
  end
end

get '/home' do
    erb :home
end

get '/profile' do
    @user = User.find session[:user_id]
    erb :profile
end

get '/signout' do

  session[:user_id] = nil
  flash[:notice] = "Signed Out Successfully. Come back soon!"
  redirect '/'
end

get '/delete' do
  User.delete session[:user_id]
  flash[:notice] = "Your account has been deleted"
  erb :delete
end



