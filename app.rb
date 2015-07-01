require 'sinatra'
require 'sinatra/activerecord'
require './models.rb'
require 'sinatra/reloader'

set :database, "sqlite3:bookface.sqlite3"

get '/sign-up' do
  erb :sign_up
end

post '/sign_up' do
  "You've Signed Up!"
end
