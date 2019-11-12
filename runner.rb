require_relative "startup.rb"
require_relative "elo.rb"
require_relative "prediction.rb"

def handler(file, coeficcient_k, coefficient_draw, home_adv, matches, coefficient_goal)
    data = read_data(file)
    teams_hash = team_elo_hash(data)
    results = result_reader(data)

    our_predictions = {home: [], away:[], draw:[]}
    results.each do |element|
        game = new_elo_calc(teams_hash, element, coeficcient_k, coefficient_draw, home_adv, matches, coefficient_goal)
        
        our_predictions = our_predictions(our_predictions, game[1], game[2])
        
        teams_hash = game[0]
    end

    # teams_hash.each do |e|
    #     puts "#{e[0]}: #{e[1][e.length - 1]}"
    # end
    
    
    return correctly_percentage(our_predictions)
end





new_file = File.new("results.txt","w")



new_file.puts("coefficient_k: ")
new_file.puts("coefficient_draw: ")
new_file.puts("home_adv: ")
new_file.puts("matches: ")
new_file.puts("coefficient_goal: ")
new_file.puts("")


handler('data_2019-11-12.csv', 20, 0.5, 1.5, 100, 1.5).each do |e|
    new_file.puts(e)
end

new_file.puts("---------")
