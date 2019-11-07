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

teams_hash = team_elo_hash(read_data('data_2019-11-05.csv'))
results = result_reader(read_data('data_2019-11-05.csv'))

p teams_hash