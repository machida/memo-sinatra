require "sinatra"
require "sinatra/reloader"
require "slim"

class Memo
  def initialize(data)
    memo_contents = []
    File.open(data, "rt") do |f|
      memo_contents = f.readlines
    end
    @title = memo_contents[0]
    @body = memo_contents[1..-1].join
  end

  def title
    @title
  end

  def body
    @body
  end

  def url
    "/#{@title}"
  end
end

get "/" do
  @title = "メモ"
  @memos = Dir.glob("data/*.txt")
  slim :index
end

get "/new" do
  @title = "新規メモ"
  slim :new
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
  @title = title
  memo = "data/#{title}.txt"
  @memo = Memo.new(memo)
  slim :show
end

get '/:title/edit' do |title|
  @title = "#{title}内容変更"
  memo = "data/#{title}.txt"
  @memo = Memo.new(memo)
  slim :edit
end

post "/:title/update" do
  @title = params[:title]
  @body = params[:body]
  File.open("data/#{@title}.txt", "r+") do |f|
    f.puts @title
    f.puts @body
  end
  redirect "/#{@title}"
end
