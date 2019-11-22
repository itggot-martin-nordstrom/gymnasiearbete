require_relative "prediction.rb"

#   Gives the goal difference in a game after full time.
#
#   game - The game that was played with all the data; a single line in the data document. ex) [E0,09/08/2019,20:00,Liverpool,Norwich,4,1,H,4,0,H...]
#
#   ft_goal_difference("E0,09/08/2019,20:00,Liverpool,Norwich,4,1,H,4,0,H...")
#       =>  3
#
def ft_goal_difference(game)
    h_score = game[5].to_i
    a_score = game[6].to_i

    difference = (h_score - a_score).abs

    return difference
end


#   Gives a new ELO rating based on a trend over the course of a certain number of matches. 
#   If this number is larger than the number of games played, the value is the latest game's ELO (- 0).
#
#   team - The team who's ELO you want to calculate before a match. ex) "Liverpool"
#   teams_hash - The hash of teams with their ELO's. ex) {"Liverpool" => [0,40,30,12,40], "Chelsea" => [0,10,31,20]}
#   matches - The amount of matches you want the trend to span. Minimum of 2. 
#
#   elo_from_matches("Liverpool", {"Liverpool" => [0,40,30,12,40]}, 2)
#       =>  28
#
#   elo_from_matches("Chelsea", {"Chelsea" => [0,10,31,20]}, 30)
#       => 20
#
def elo_from_matches(team, teams_hash, matches)
    team_elo_arr = teams_hash[team]
    # p team_elo_arr
    latest_elo = team_elo_arr[team_elo_arr.length - 1]

    if team_elo_arr.length > matches
        elo = latest_elo - team_elo_arr[team_elo_arr.length - matches]
    else
        elo = latest_elo
    end

    return elo
end


#THE R'A OF THE CALCULATION
def new_elo_calc(hash, game, coefficent_k, coefficent_draw, home_adv, matches, coefficent_goal)

    goal_difference = coefficent_goal**ft_goal_difference(game)
    # goal_difference = 1
    h_team = game[3]
    a_team = game[4]
    result = game[7]
    # matches = 5

    h_team_elo = elo_from_matches(h_team, hash, matches) * home_adv
    a_team_elo = elo_from_matches(a_team, hash, matches)

    h_expected = expected_output(h_team_elo, a_team_elo)
    a_expected = expected_output(a_team_elo, h_team_elo)


    #THESE NUMBERS DETERMINE THE PREDICTION PERCENTAGE, AMONG OTHER THINGS
    # coefficent_k = 18.00
    coefficent_win = 1.00
    # coefficent_draw = 0.40
    coefficent_loss = 0.00


    if result == "H"
        hash[h_team] << h_team_elo + coefficent_k * (coefficent_win - h_expected) + goal_difference
        hash[a_team] << a_team_elo + coefficent_k * (coefficent_loss - a_expected) + goal_difference
        
    elsif result == "A"
        hash[h_team] << h_team_elo + coefficent_k * (coefficent_loss - h_expected) + goal_difference
        hash[a_team] << a_team_elo + coefficent_k * (coefficent_win - a_expected) + goal_difference

    elsif result == "D" 
        hash[h_team] << h_team_elo + coefficent_k * (coefficent_draw - h_expected) + goal_difference
        hash[a_team] << a_team_elo + coefficent_k * (coefficent_draw - a_expected) + goal_difference
    end

    

    prediction_outcome = predicted_correctly(h_team_elo, a_team_elo, game, 25)

    return hash, prediction_outcome, result
end


