require 'json'
require 'open-uri'

class GamesController < ApplicationController

  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
    return @letters
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english(url)
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    @result = user['found']
    return @result
  end

  def time
    4
  end

  def score
    user_input = params[:input].upcase
    if included?(user_input, params[:grid].split(' '))
      if english( "https://wagon-dictionary.herokuapp.com/#{params[:input]}")
        @output = "Well done! Your score is #{time}"
      else
        @output = "Sorry this is not an english word, please try again"
      end
    else
      @output = "Sorry but #{params[:input]} can't be built out of #{params[:grid]}"
    end
    return @output
  end
end
