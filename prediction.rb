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
    
        percentage = "Correct of #{e[0].capitalize}: #{count/(array.length * 1.00)} (#{count}/#{array.length})"
        output << percentage
    end

    output << "Correct of All: #{correct_matches*1.0/number_of_matches} (#{correct_matches}/#{number_of_matches})"

    return output
end