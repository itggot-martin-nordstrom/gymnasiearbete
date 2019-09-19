def read_data(file)
    data = File.readlines(file).map do |element|
        array = element.split(",")
    end

    return data
end



# TEAM RESET
def team_hash(data)
    teams = {}
    data.map do |element|
        if element[3] != "HomeTeam"
            teams[element[3]] = 0
        end
    end

    return teams
end


def result_reader(data)
    results = data.select do |element|
        element[0] != "Div"
    end

    return results
end


def expected_result_calc(hash, team1, team2, result)
    team1_elo = hash[team1]
    team2_elo = hash[team2]

    if team1_elo > team2_elo
        expected_winner = team1
    elsif team1_elo < team2_elo
        expected_winner = team2
    else 
        expected_winner = "none"
    end

    if result == "H"
        winner = team1
        loser = team2
    elsif result == "A"
        winner = team2
        loser = team1
    else 
        winner = "none"
    end


    # p expected_winner
    # p winner

    
    if expected_winner == winner
        expected = true
    else
        expected = false
    end
    
    if result == "D"
        expected = "draw"
    end

    
    
    return team1, team2, expected
    
end


def value_calc(hash, team1, team2, result, expected)
    team1_elo = hash[team1]
    team2_elo = hash[team2]
    
    difference = (team1_elo - team2_elo).abs.to_i
    
    sway_from_one = 0.1/1.0000

    p expected
    p sway_from_one

    if expected == true
        expect_coefficient = (1.00 - sway_from_one) * 1.00
    elsif expected == false
        expect_coefficient = (1.00 + sway_from_one) * 1.00
    else
        expect_coefficient = 1.00
    end
    
    p expect_coefficient

    coefficient = 5.00
    # Värdet 8 går att variera, MEN VILKEN PÅVERKAN HAR DEN? Hur kan man beskriva det på ett bra sätt?
    # Om skillnaden = 0 vinner eller förlorar man 8 "poäng"
    # Om skillnaden är stor vinner/förlorar man färre poäng 
    # Om skillnaden är liten vinner/förlorar man fler poäng 

    p difference
    p (expect_coefficient**(difference+0.05))
    
    change_value = (expect_coefficient**(difference+0.05)) * coefficient

    
    # Om värdet är 0.5 hamnar de på samma position efter matchen => stor påverkan
    # Om värdet är 0 påverkar en lika match inget => liten påverkan
    draw_change = change_value * 0.20


    if team1_elo > team2_elo && expected == true
        hash[team1] += change_value
        hash[team2] -= change_value
    elsif team1_elo > team2_elo && expected == false
        hash[team1] -= change_value
        hash[team2] += change_value
    
    
    elsif team1_elo < team2_elo && expected == true
        hash[team1] -= change_value
        hash[team2] += change_value
    elsif team1_elo < team2_elo && expected == false
        hash[team1] += change_value
        hash[team2] -= change_value
    

    elsif result == "D" && team1_elo > team2_elo
        hash[team1] -= draw_change
        hash[team2] += draw_change
    elsif result == "D" && team1_elo < team2_elo
        hash[team1] += draw_change
        hash[team2] -= draw_change
    end

    return hash
end

def runner()
    data = read_data("results_20190917.csv")
    teams = team_hash(data)
    results = result_reader(data)

    results.each do |element|
        expected = expected_result_calc(teams, element[3], element[4], element[7])
        teams = value_calc(teams, element[3], element[4], element[7], expected[2])
        p teams
    end

    teams = teams.sort_by {|_key, value| value}.to_h
    
    return teams.to_a

end




## NEW FILE MAKER
new_file = File.new("results.txt","w+")

File.open("results.txt", "w+") do |e|
    e.puts(runner())
  end
