# THE Ea & Eb OF THE CALCULATION
#   Gives a percentage of likelyhood of a team winning.
#
#   want to team_elo - The ELO of the team who's percentage you calculate
#   opp_elo - The ELO of their opponent
#
#   expected_output(70, 35)
#       =>  0.55019...
#
#   expected_output(35, 70)
#       =>  0.44980...
#
#   expected_output(100, 0)
#       =>  0.64006...
#
def expected_output(team_elo, opp_elo)
    exponent = (opp_elo - team_elo)/400.00
    expected_output = 1.00/(1.00 + 10.00**exponent)

    return expected_output
end

#   Determines if we predicted the outcome of a game correctly.
#
#   h_team_elo - The home team's ELO before the game.
#   a_team_elo - The away team's ELO before the game.
#   game - The game that was played with all the data; a single line in the data document. ex) [E0,09/08/2019,20:00,Liverpool,Norwich,4,1,H,4,0,H...]
#   leniency - Determines in what span we predict draws. A value of 35 gives ~55/45. 
#
#   predicted_correctly(100, 0, [E0...Liverpool,Norwich,4,1,H...], 40)
#       =>  true
#
#   predicted_correctly(57, 63, [E0...Liverpool,Norwich,4,1,H...], 10)
#       =>  true
#
#   predicted_correctly(50, 70, [E0...Liverpool,Norwich,4,1,H...], 10)
#       =>  false
#
def predicted_correctly(h_team_elo, a_team_elo, game, leniency)
    predicted_correctly = false
    result = game[7]

    if result == "H" && h_team_elo > a_team_elo && (h_team_elo - a_team_elo).abs > leniency
        predicted_correctly = true
    elsif result == "A" && h_team_elo < a_team_elo && (h_team_elo - a_team_elo).abs > leniency
        predicted_correctly = true
    elsif result == "D" && (h_team_elo - a_team_elo).abs <= leniency
        predicted_correctly = true
    end

    return predicted_correctly
end

#   Collects the predictions based on how it ended.
#
#   prediction - IF we predicted the game correctly. True or false
#   outcome - How the game ended. Home win, away win or draw 
#
#   predicted_correctly({home: [], away:[], draw:[]}, true, "H")
#       =>  {home: [true], away:[], draw:[]}
#
#   predicted_correctly({home: [], away:[], draw:[]}, false, "A")
#       =>  {home: [], away:[false], draw:[]}
#
#   predicted_correctly({home: [], away:[], draw:[]}, false, "H")
#       =>  {home: [true, false], away:[], draw:[]}
#
def our_predictions(hash, prediction, outcome)
    if outcome == "H"
        hash[:home] << prediction
    elsif outcome == "A"
        hash[:away] << prediction
    elsif outcome == "D"
        hash[:draw] << prediction
    end

    return hash
end


#   Gives the precentages of correctly predicted games.
#
#   hash - {home: [true, false, true, true], draw: [true], away:[false, true]}
#
#   tester = {home: [true, false, true, true], draw: [true], away:[false, true]}
#   correctly_percentage(tester)
#       =>  ["Correct of Home: 0.75, (3/4)" ... "Correct of All: 0.6666666, (6/9)"]
#
def correctly_percentage(hash)
    output = []
    
    correct_matches = 0
    number_of_matches = 0

    hash.each do |e|
        array = e[1]

        number_of_matches += array.length
        i = 0
        count = 0
        while i < array.length
            if array[i] == true
                count += 1
                correct_matches += 1
            end   
            i += 1
        end
    
        percentage = count*1.0/array.length
        output << percentage
    end

    output << correct_matches*1.0/number_of_matches

    return output
end