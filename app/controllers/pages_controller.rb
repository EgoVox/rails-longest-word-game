require 'net/http'
require 'uri'
require 'json'

class PagesController < ApplicationController
  def game
  @letters = []
  vowels = %w[a e i o u]
  consonants = ('a'..'z').to_a - vowels

    a = rand(3..5)
    a.times do
      @letters << vowels.sample
    end

    b = 10 - a
    b.times do
    @letters << (vowels + consonants).sample
  end

    @letters.shuffle!
  end

  def gamescore
    i = 0
    @error = "Good ! All letters are in range"
    @string = params[:letters].to_s
    @userinput = params[:word].to_s
    word_input = @userinput.chars
    checkchars = @string.chars

    while i < word_input.size
      unless checkchars.include?(word_input[i])
        @error = "FAILED ! You use a letter not in the range"
        break
      end
      i += 1
    end

    uri = URI("https://dictionary.lewagon.com/#{@userinput}")
    res = Net::HTTP.get_response(uri)
    @body = res.body if res.is_a?(Net::HTTPSuccess)
    if @body.include?("word not found")
      @body = "Dumb. Word is not found !"
    else
      @body = "Great. Word is found !"

    end

    if @string.include?(@userinput)
      @answer = "tocard"
    end
  end
end
