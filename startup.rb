

# def read_data(file)
#     data = File.readlines(file).map do |element|
#         array = element.split(",")
#     end

#     return data
# end

require 'csv'

def csv_to_h(file)
    data = CSV.read(file, headers: true)
    rows = data.map { |r| r.to_h }
    return rows
end

# TEAM RESET
def team_elo_hash(data)
    teams = {}
    data.each do |element|
        teams[element["HomeTeam"]] = [0]
    end

    return teams
end

# p team_elo_hash(read_data('data_2019-11-05.csv'))

# #ARRAY OF ALL PLAYED RESULTS
# def result_reader(data)
#     results = data.select do |element|
#         element[0] != "Div"
#     end

#     return results
# end

# teams_hash = team_elo_hash(read_data('data_2019-11-05.csv'))
# results = result_reader(read_data('data_2019-11-05.csv'))

# p teams_hash
# p results