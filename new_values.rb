def goal_difference(h_score, a_score)
    h_score = h_score.to_i
    a_score = a_score.to_i

    difference = (h_score - a_score).abs

    return difference
end

#THE R'A OF THE CALCULATION
def new_value_calc(h_team, a_team, hash, result)

    def stuff()
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


    end

    # p hash[h_team]

    return hash, [predicted_correctly, result]
end