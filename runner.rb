
require_relative "optimising.rb"



#OPTIMISING
def optimal_handler(results)
    number_of_saved = 3

    i = number_of_saved
    # p results[0]

    max_array = []

    number_of_saved -= 1
    while number_of_saved >= 0
        max_array << results[number_of_saved]
        
        number_of_saved -= 1
    end

    while i < results.length
        max_array = max_percentage(max_array, results[i])
        i += 1
    end

    return max_array

end


start_time = Time.now
optimal_handler(results_handler()).each do |e|
    puts e
    puts " "
end

puts Time.now - start_time