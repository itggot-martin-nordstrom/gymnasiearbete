# require_relative "runner.rb"
require_relative "startup.rb"
require_relative "elo.rb"
require_relative "prediction.rb"
require_relative "optimising.rb"

# new_file = File.new("results.txt","w")

def value_generator(start, limit, jump)
    values_array = []
    i = start

    while i <= limit
        values_array << i
        i += jump
    end

    return values_array
end


def results_handler()
    results = []
    file = 'results_2016-2017season.csv'
    game_results = csv_to_h(file)
    teams_hash = team_elo_hash(game_results)
    # p results

    value_generator(0,0.2,0.1).each do |draw|
        value_generator(100,100,1).each do |matches|
            value_generator(1.0,1.1,0.01).each do |home_adv|
                value_generator(1,5,0.4).each do |goal|
                    value_generator(0,0,1).each do |leniency|
                        value_generator(20,40,2).each do |k|
                            array = []

                            program_handler(teams_hash, game_results, k, draw, home_adv, matches, goal, leniency).each do |e|
                                array << e
                            end

                            hash = {}

                            hash[:k] = k
                            hash[:draw] = draw
                            hash[:home_adv] = home_adv
                            hash[:matches] = matches
                            hash[:goal] = goal
                            hash[:leniency] = leniency
                                                    
                            array << hash

                            results << array
                        end
                    end
                end
            end
        end
    end

    
    return results
end


def max_percentage(saved, comp_array)
    i = 0
    lowest_index = 0

    while i < saved.length

        if saved[i][3] < saved[lowest_index][3]
            lowest_index = i
        end

        i += 1
    end

    if comp_array[3] > saved[lowest_index][3]
        saved[lowest_index] = comp_array
    elsif comp_array[3] == saved[lowest_index][3]
        saved << comp_array
    end

    return saved
end





def program_handler(teams_hash, results, coeficcient_k, coefficient_draw, home_adv, matches, coefficient_goal, leniency)

    our_predictions = {home: [], away:[], draw:[]}
    results.each do |element|
        game = new_elo_calc(teams_hash, element, coeficcient_k, coefficient_draw, home_adv, matches, coefficient_goal, leniency)
        
        our_predictions = our_predictions(our_predictions, game[1], game[2])
        
        teams_hash = game[0]
    end

    # teams_hash.each do |e|
    #     puts "#{e[0]}: #{e[1][e.length - 1]}"
    # end
    
    return correctly_percentage(our_predictions)
end