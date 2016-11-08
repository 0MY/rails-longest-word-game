class LgWordController < ApplicationController
  def game
    @grid = generate_grid(9)
    @grid_raw = @grid.join() # to transform array 'grid' into string
    @grid_space = @grid.join(" ") # same with space in between each char for better display   byebug
    @start_time = Time.now
  end

  def score
    end_time = Time.now
    attempt = params[:attempt]
    start_time = Time.parse(params[:start_time])
    guess_time = end_time - start_time
    grid = params[:grid].split("") # transforms back string into array of chars
    @result = run_game(attempt, grid, guess_time)

  end

  def generate_grid(grid_size)
    #  TODO: generate and return a random grid of 'grid_size' letters (array of char)
    prng = Random.new
    rndletters = []
    for i in (1..grid_size) do
      rndletters << prng.rand(65...65 + 26) # 'A' + 26 letters -1 --> 'Z'
    end
    rndletters.map { |x| x.chr } # switch array of random numbers into array of chars
  end

  def run_game(attempt, grid, guess_time)
    # TODO: runs the game and return detailed hash of result

    # binding.pry

    # Check if word is a grid combination:
    # for each letter.upcase of attempt, check if in grid using #each and #index
    #   if YES then remove letter from grid (based on its index), and run
    #   again check with next attempt's letter
    #   if NO then KO
    #   if KO then score = 0 + msg to user
    substring = true # flag to false if no match
    attempt.upcase.each_char do |x|
      grid.index(x).nil? ? substring = false : grid.delete_at(grid.index(x))
    end
    if substring == false
      score = 0
      msg = "not in the grid"
    else
      #   if OK then check if translation exists, i.e. word exists,
      translation = translate(attempt)
      if translation == "" || translation == attempt
        # if KO then score = 0 + msg to user + translation = nil (for rake!)
        translation = nil
        score = 0
        msg = "not an english word"
      else
        # if OK then display score
        score = (1000 * attempt.length / (guess_time)).round
        msg = "well done"
      end
    end
    return { time: guess_time, translation: translation, score: score, message: msg }
  end

  def translate(try)
    key = "819b5e22-aefd-474b-8a13-46ec364d2d68"
    url_base = "https://api-platform.systran.net/translation/text/translate?input="
    context = "&source=en&target=fr&encoding=utf-8&key="
    url = url_base + try + context + key
    # p "URL = #{url}"
    translate_serialized = open(url).read
    # PENSER A FAIRE UN CHECK D'ERREUR DE CONNEXION + BASCULE SUR DICO LINUX
    # The hash returned by JSON is a hash of array of hash of hash (until stats elements)
    # So, to address the translation elements, we go through a hash / array / hash
    JSON.parse(translate_serialized)["outputs"][0]["output"]
  end
end
