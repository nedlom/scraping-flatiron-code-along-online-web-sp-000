require 'nokogiri'
require 'open-uri'
require 'pry'

class CLI
  def list_books
    url = "https://en.wikipedia.org/wiki/Time%27s_List_of_the_100_Best_Novels"
    list = Scraper.new(url)
    list.get_books.each.with_index do |b, i|
      Book.new(b.text, b['href'])
      puts "#{i + 1}. #{b.text}"
    end
  end
  
end

class Scraper
  attr_accessor :url
  
  def initialize(url)
    @url = url
  end
  
  def get_page
    Nokogiri::HTML(open(url))
  end
  
  def get_books
    page = self.get_page
    page.css("table.wikitable tbody tr td i a")
  end
  
end

class Book
  attr_accessor :name, :url
  @@all = []
  
  def initialize(name, url)
    @name = name
    @url = "https://en.wikipedia.org/" + url
    @@all << self
  end
  
  def self.all
    @@all
  end
  
  def self.get_by_name(name)
    @@all.detect {|b| b.name == name}
  end
end

# CLI.new.list_books
# binding.pry