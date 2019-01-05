require "sinatra"
require "sinatra/reloader"

get "/" do
  erb :index
end

get "/new" do
  erb :new
end

post "/create" do
  @title = params[:title]
  @body = params[:body]
  File.open("data/#{@title}.txt", "w"){|f|
    f.puts @title
    f.puts @body
  }
  redirect "/#{@title}"
end

get '/:title' do |title|
  f = File.open("data/#{title}.txt")
  s = f.read
  f.close
  p s
end
