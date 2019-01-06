require "sinatra"
require "sinatra/reloader"

class Memo
  def initialize(data)
    memo_contents = []
    File.open(data, mode = "rt") do |f|
      memo_contents = f.readlines
    end
    @title = memo_contents[0]
    @body = memo_contents[1]
  end

  def title
    @title
  end

  def body
    @body
  end
end

get "/" do
  @memos = Dir.glob("data/*.txt")
  erb :index
end

get "/new" do
  erb :new
end

post "/create" do
  @title = params[:title]
  @body = params[:body]
  File.open("data/#{@title}.txt", "w") do |f|
    f.puts @title
    f.puts @body
  end
  redirect "/#{@title}"
end

get '/:title' do |title|
  @memo = "data/#{title}.txt"
  erb :show
end
