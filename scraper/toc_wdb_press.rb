require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'nokogiri'
end

require 'open-uri'
require 'set'

doc = Nokogiri::HTML(URI.open("https://gihyo.jp/magazine/wdpress/archive/2022/vol#{ARGV.first}"))

class Content
  attr_accessor :title, :chapters

  def initialize(title)
    @title = title
    @chapters = []
  end

  def to_s
    str = "## #{@title}\n"
    @chapters.each do |c|
      str << "- #{c}\n"
    end

    str
  end
end

contents = []

doc.css('#toc h3,.toc').each do |element|
  if element.name == 'h3'
    contents << Content.new(element.text.gsub("\r\n", ' '))
  elsif element.name == 'ul'
    element.css('li').each do |ch|
      c = contents.last
      c.chapters << ch.text.gsub("\r\n", ' ')
    end
  end
end

puts contents.join("\n")

#binding.irb
