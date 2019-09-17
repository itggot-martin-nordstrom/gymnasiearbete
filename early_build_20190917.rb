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

    change_value = (0.90**difference) * 10
    draw_change = change_value * 0.4

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
    return teams

end


new_file = File.write("results.txt",runner())
