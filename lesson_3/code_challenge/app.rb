require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "pry"
require "psych"

before do
  @users = Psych.load_file("data/users.yaml")
end

helpers do
  def count_interests
    total = 0
    @users.each_pair do |user, attributes|
      total += attributes[:interests].size
    end
    total
  end
end

get "/" do
  erb :index
end

get "/users/:name" do
  @attributes = @users[params[:name].to_sym]
  @interests = @attributes[:interests]
  @name = params[:name].capitalize
  erb :user
end