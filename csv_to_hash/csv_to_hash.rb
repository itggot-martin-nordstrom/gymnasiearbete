require 'csv'

def csv_to_h(file)
    data = CSV.read(file, headers: true)
    rows = data.map { |r| r.to_h }
    return rows
end

csv_to_h('results_20190917.csv').each do |e|
    p e["HomeTeam"]
end