
# THE Ea & Eb OF THE CALCULATION
def expected_output(team_elo, opp_elo)
    exponent = (opp_elo - team_elo)/400.00
    expected_output = 1.00/(1.00 + 10.00**exponent)

    return expected_output
end

#100 POINTS DIFFERENCE IS A 64% WIN, CHANGE THE 400 FOR CHANGE IN THISS
# p expected_output(100, 00)


def predictions(prediction, outcome)

    hash = {home: [], away:[], draw:[]}

    if outcome == "H"
        hash[:home] << prediction
    elsif outcome == "A"
        hash[:away] << prediction
    elsif outcome == "D"
        hash[:draw] << prediction
    end

    return hash
end

def correctly_percentage(hash)
    percentages = []
    
    hash.each do |e|
        array = e[1]

        i = 0
        count = 0
        while i < array.length
            if array[i] == true
                count += 1
            end   
            i += 1
        end
    
        precentage = count/(array.length * 1.00)
        percentages << precentage
    end

    return percentages
end

tester = {home: [true, false, true, true], draw: [true], away:[false, true]}

p correctly_percentage(tester)