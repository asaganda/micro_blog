require 'sinatra'
require 'sinatra/activerecord'
require './models.rb'
require 'sinatra/reloader'
require 'rack-flash'

set :database, "sqlite3:bookface.sqlite3"

enable :sessions

use Rack::Flash, sweep: true

configure(:development){set :database, "sqlite3:bookface.sqlite3"}

# this method is defining who the current user is with an if statement
def current_user
  if session[:user_id]
    User.find session[:user_id]
  end
end

# this routes to the sign-up/sign-in page
get '/' do
  erb :sign_up
end

# After someone signs-up as a user, their info such as username/email/passwod are recorded in a table named users
# The User.create makes the line above possible. The purple before "=>" are keys and the purple in the [] are the values
# The params are there because they're taking in what the user is typing in through the form which is on the sign_up.erb
# this whole concept is named a hash.
post '/signup' do
  @user = User.create :username => params[:username], :email => params[:email], :password => params[:password]
  session[:user_id] = @user.id
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
  if current_user
    user_id = current_user
    @post = User.find(user_id).posts
    erb :home
  end
end

post '/post' do
  Post.create :body => params[:post], :user_id => session[:user_id]
  redirect '/home'
end

get '/profile' do
    @user = User.find session[:user_id]
    if current_user
      user_id = current_user
      @post = User.find(user_id).posts
    end
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

# get '/profile/edit' do
#   @user = User.find(session[:user_id]).update_attributes(:username)
# end




