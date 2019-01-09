require "sinatra"
require "sinatra/reloader"
require "slim"
require "redcarpet"

class Memo
  def initialize(data)
    memo_contents = []
    File.open(data, "rt") do |f|
      memo_contents = f.readlines
    end
    @id = memo_contents[0]
    @created_at = memo_contents[1]
    @title = memo_contents[2]
    @body = memo_contents[3..-1].join
  end

  def id
    @id
  end

  def title
    @title
  end

  def body
    @body
  end

  def url
    "/#{@id}"
  end
end

helpers do
  def markdown(text)
    unless @markdown
      renderer = Redcarpet::Render::HTML.new
      @markdown = Redcarpet::Markdown.new(renderer)
    end

    @markdown.render(text)
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
  @id = SecureRandom.urlsafe_base64(8)
  @created_at = Time.now
  @title = params[:title]
  @body = params[:body]
  File.open("data/#{@id}.txt", "w") do |f|
    f.puts @id
    f.puts @created_at
    f.puts @title
    f.puts @body
  end
  redirect "/#{@id}"
end

get '/:id' do |id|
  @id = id
  memo = "data/#{id}.txt"
  @memo = Memo.new(memo)
  slim :show
end

get '/:id/edit' do |id|
  @id = "#{id}内容変更"
  memo = "data/#{id}.txt"
  @memo = Memo.new(memo)
  slim :edit
end

post "/:id/update" do
  @id = params[:id]
  @title = params[:title]
  @body = params[:body]
  File.open("data/#{@id}.txt", "r+") do |f|
    f.puts @id
    f.puts @created_at
    f.puts @title
    f.puts @body
  end
  redirect "/#{@id}"
end

get "/:id/delete" do
  @id = params[:id]
  File.delete("data/#{@id}.txt")
  redirect "/"
end
