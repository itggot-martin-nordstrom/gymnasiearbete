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


def value_calc(hash, team1, team2, result)
    team1_elo = hash[team1]
    team2_elo = hash[team2]

    difference = (team1_elo - team2_elo).abs.to_i

    # Värdet 8 går att variera, MEN VILKEN PÅVERKAN HAR DEN? Hur kan man beskriva det på ett bra sätt?
    # Om skillnaden = 0 vinner eller förlorar man 8 "poäng"
    # Om skillnaden är stor vinner/förlorar man färre poäng 
    # Om skillnaden är liten vinner/förlorar man fler poäng 

    
    # Man måste ha ett annat värde på 1-x för att kunna räkna om det blir skräll. Då ska påverkan vara stor!!
    change_value = (0.94**difference) * 5

    # Om värdet är 0.5 hamnar de på samma position efter matchen => stor påverkan
    # Om värdet är 0 påverkar en lika match inget => liten påverkan
    draw_change = change_value * 0.2

    if result == "H"
        hash[team1] += change_value
        hash[team2] -= change_value
    elsif result == "A"
        hash[team1] -= change_value
        hash[team2] += change_value

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
        teams = value_calc(teams, element[3], element[4], element[7])
    end

    teams = teams.sort_by {|_key, value| value}.to_h
    
    return teams.to_a

end




## NEW FILE MAKER
new_file = File.new("results.txt","w+")

File.open("results.txt", "w+") do |e|
    e.puts(runner())
  end
