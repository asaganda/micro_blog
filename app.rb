require 'sinatra'
require 'sinatra/activerecord'
require './models.rb'

set :database, "sqlite3:bookface.sqlite3"

get ‘/sign-up’ do
  erb :sign_up
end
