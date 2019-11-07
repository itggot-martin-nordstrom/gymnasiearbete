def read_data(file)
    data = File.readlines(file).map do |element|
        array = element.split(",")
    end

    return data
end

# TEAM RESET
def team_elo_hash(data)
    teams = {}
    data.map do |element|
        if element[3] != "HomeTeam"
            teams[element[3]] = [0]
        end
    end

    return teams
end

#ARRAY OF ALL PLAYED RESULTS
def result_reader(data)
    results = data.select do |element|
        element[0] != "Div"
    end

    return results
end

def goal_difference(h_score, a_score)
    h_score = h_score.to_i
    a_score = a_score.to_i

    difference = (h_score - a_score).abs

    return difference
end


# THE Ea & Eb OF THE CALCULATION
def expected_output(team_elo, opp_elo)
    exponent = (opp_elo - team_elo)/400.00
    expected_output = 1.00/(1.00 + 10.00**exponent)

    return expected_output
end

#100 POINTS DIFFERENCE IS A 64% WIN, CHANGE THE 400 FOR CHANGE IN THISS
# p expected_output(100, 00)

#THE R'A OF THE CALCULATION
def new_value_calc(h_team, a_team, hash, result, h_goals, a_goals)

    match_numbers = 5

    h_team_current_elo = hash[h_team][hash[h_team].length - 1] * 1.00
    a_team_current_elo = hash[a_team][hash[a_team].length - 1] * 1.00

    if hash[h_team].length > match_numbers
        h_team_elo = h_team_current_elo - hash[h_team][hash[h_team].length - match_numbers] * 1.00
    else
        h_team_elo = h_team_current_elo
    end

    if hash[a_team].length > match_numbers
        a_team_elo = a_team_current_elo - hash[a_team][hash[a_team].length - match_numbers] * 1.00
    else
        a_team_elo = a_team_current_elo
    end


    # goal_difference = 1.30**goal_difference(h_goals, a_goals)
    goal_difference = 1

    h_expected = expected_output(h_team_elo, a_team_elo)
    a_expected = expected_output(a_team_elo, h_team_elo)

    #THESE NUMBERS DETERMINE THE PREDICTION PERCENTAGE, AMONG OTHER THINGS
    coefficent_k = 18.00
    coefficent_win = 1.00
    coefficent_draw = 0.40
    coefficent_loss = 0.00

    # p h_team_elo + coefficent_k * (coefficent_win - h_expected)
    predicted_correctly = false

    if result == "H"
        hash[h_team] << h_team_elo + coefficent_k * (coefficent_win - h_expected) * goal_difference
        hash[a_team] << a_team_elo + coefficent_k * (coefficent_loss - a_expected) * goal_difference
        
        if h_team_elo > a_team_elo
            predicted_correctly = true
        end
    elsif result == "A"
        hash[h_team] << h_team_elo + coefficent_k * (coefficent_loss - h_expected) * goal_difference
        hash[a_team] << a_team_elo + coefficent_k * (coefficent_win - a_expected) * goal_difference

        if a_team_elo > h_team_elo
            predicted_correctly = true
        end

    elsif result == "D" 
        hash[h_team] << h_team_elo + coefficent_k * (coefficent_draw - h_expected) * goal_difference
        hash[a_team] << a_team_elo + coefficent_k * (coefficent_draw - a_expected) * goal_difference

        #IS HOW LENIENT WE ARE WHEN COUNTING WITH DRAWS
        #40 GIVES A 55/45 WIN
        coefficent_draw_leniency = 40

        if (a_team_elo - h_team_elo).abs < coefficent_draw_leniency
            predicted_correctly = true
        end

    end

    # p hash[h_team]

    return hash, predicted_correctly
end


def predicted_percentage_calc(prediction_array)
    i = 0

    count = 0.00

    while i < prediction_array.length
        if prediction_array[i] == true
            count += 1.00
        end

        i += 1
    end

    precentage = count/(prediction_array.length * 1.00)

    return precentage
end

def runner()
    data = read_data("results_20191015.csv")
    teams = team_elo_hash(data)
    results = result_reader(data)

    predictions_result = []
    
    results.each do |element|
        game = new_value_calc(element[3], element[4], teams, element[7], element[5], element[6])
        
        teams = game[0]
        predictions_result << game[1]
    end
    
    # p predictions_result
    p predicted_percentage_calc(predictions_result)
    teams = teams.sort_by {|_key, value| value}.to_h

    return teams.to_a

end

## NEW FILE MAKER
new_file = File.new("results.txt","w+")

File.open("results.txt", "w+") do |e|
    e.puts(runner())
  end