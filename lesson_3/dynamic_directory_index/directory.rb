require "sinatra"
require "sinatra/reloader"
require 'tilt/erubis'
require 'pry'

get "/" do
  @files = Dir.glob("*", base: "public").sort
  @files.reverse! if params["sort"] == "desc"
  erb :index
end