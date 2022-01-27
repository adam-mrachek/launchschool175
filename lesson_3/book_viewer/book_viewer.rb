require "sinatra"
require "sinatra/reloader"
require 'tilt/erubis'
require 'pry'

before do
  @chapters = File.readlines("data/toc.txt", chomp: true)
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map.with_index do |text, index|
      "<p id=#{index}>#{text}</p>"
    end.join
  end

  def each_paragraph(text)
    text.split("\n\n").each_with_index do |paragraph, index|
      yield paragraph, index
    end
  end

  def highlight_matching_text(text)

  end

  def search_chapters(query)
    results = []
    return results if !query || query.empty?

    @chapters.each_with_index do |chapter_name, index|
      number = index + 1
      contents = File.read("data/chp#{number}.txt")
      if contents.include?(query)
        result = {number: number, name: chapter_name, paragraphs: []}
        each_paragraph(contents) do |paragraph, index|
          if paragraph.include?(query)
            paragraph = paragraph.gsub(/#{query}/, "<strong>#{query}</strong>")
            result[:paragraphs] << {text: paragraph, id: index}
          end
        end
        results << result
      end
    end
    results
  end
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i
  chapter_name = @chapters[number - 1]

  redirect "/" unless (1..@chapters.size).cover?(number)

  @title = "Chapter #{number}: #{chapter_name}"
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get "/search" do
  search_term = params[:query]

  @results = search_chapters(search_term)
  erb :search
end

not_found do
  redirect "/"
end
