# set up different char from different dice
dice = [["AAEEGN"],["ELRTTY"],["AOOTTW"],["ABBJOO"],["EHRTVW"],["CIMOTU"],["DISTTY"],["EIOSST"],["DELRVY"],["ACHOPS"],["HIMNQU"],["EEINSU"],["EEGHNW"],["AFFKPS"],["HLNNRZ"],["DEILRX"]]

# set up size of board
board = [["_", "_", "_", "_"], ["_", "_", "_", "_"], ["_", "_", "_", "_"], ["_", "_", "_", "_"]]

# to choose the char from dice pool
def dice_suffle(dice)
    array_dice = []
    array_word = []
    i = 0
    while i < dice.length do 
        random = dice[rand(dice.length)]
        # to make sure no repeat dice is used
        if array_dice.include?(random) === false
            # push the dice number in the pool into array
            array_dice << random
            # choose the char from the dice
            random_word = random[0][rand(6)]
            # change the char from q to qu
            if random_word === "Q"
                random_word = "Qu"
            end
            # push the char into an array
            array_word << random_word
            i += 1
        end
    end
    return array_word
end
            
def shake(board, dice)
    array_word = dice_suffle(dice)
    i = 0
    j = 0
    k = 0
    # to put all the char chosen into the board
    while i < board.length do
        while j < 4 do
            board[i][j] = array_word[k].ljust(3)
            j += 1
            k += 1
        end
        i += 1
        j = 0
    end
    return board
end

# game paly
def loop(board)
    # print out all the char in the board
    board.each do |item|
        string = item.to_s
        string = string[1..-2]
        puts string.gsub(/[",]/, "")
        puts "\n"
    end

    total = 0
    # keep running unless player give up
    while true do
        puts "Enter the word: (enter 'exit!!!' to exit the game)"
        # player able to input upper case or lower case char
        input = gets.chomp.upcase
        if input === "exit!!!"
            puts "Total Point: #{total}"
            break
        end
        # if the input is not exit, check the board to calculate the point
        result = check(board, input)
        if result === true
            # every char after 2nd char will get 1 point
            if input.length > 2
                total += input.length - 2
            end
        end
        puts "Accumulate Point: #{total}"
        puts "\n"
    end
end

# to check the word is valid or not
def check(board, input)
    # to put board into 1 same array
    big_array = []
    board.each do |item|
        item.each do |nested_item|
            big_array << nested_item.sub(/\s+/, "")
        end
    end
    
    # to get all the matched char (coordinate) in the input from the board
    # something like [[0,1],[1,2]]
    index_array = []
    i = 0
    while i < input.length do
        temp_array = []
        j = 0
        while j < big_array.length do
            if big_array[j] === input[i]
                temp_array << j
            end
        j += 1
        end
        index_array << temp_array
        i += 1
    end

    # to join to become specificset of number that represent the number of the input
    # something line [[0,1],[0,2],[1,1],[1,2]]
    first_array = []
    temporary_array = []
    k = 0
    counter = true
    while k < index_array.length do
        update_array = []
        l = 0
        # only first time run this
        if counter === true
            while l < index_array[0].length do
                temporary_array << index_array[0][l]
                first_array << temporary_array
                temporary_array = []
                l += 1
            end
            counter = false
        elsif counter === false
            # need ti clone the element before continue, if not error
            m = 0
            while m < index_array[0].length do
                first_array.each do |element|
                    update_array << element.clone
                end
                m += 1
            end
            n = 0
            while l < index_array[0].length do
                times = 0
                while n < update_array.length do
                    if times < first_array.length
                        update_array[n] << index_array[0][l]
                        times += 1
                        temp = n + 1
                    end
                    n += 1
                end
                n = temp
                l += 1
            end
            first_array = update_array
        end
        # remove the element when done
        index_array.shift
    end

    word_length = first_array[0].length
    new_array = []
    new_single_array = []
    iterator = 0
    while iterator < first_array.length do
        iterator_2 = 0
        # continue check until all char in input used
        while iterator_2 < word_length - 1 do
            # check the second number is not besides the first number
            if first_array[0][iterator_2] === 0 && (first_array[0][iterator_2] + 1 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] + 4 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] + 5 === first_array[0][iterator_2 + 1])
                # if does, push to an array
                new_single_array << first_array[0][iterator_2].clone
                # if the char test is last char, push the whole word into a new array
                if iterator_2 === word_length - 2
                    new_single_array << first_array[0][-1]
                    new_array << new_single_array.clone
                    new_single_array = []
                    first_array.shift
                end
                iterator_2 += 1
            elsif first_array[0][iterator_2] === 3 && (first_array[0][iterator_2] - 1 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] + 4 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] + 3 === first_array[0][iterator_2 + 1])
                new_single_array << first_array[0][iterator_2].clone
                if iterator_2 === word_length - 2
                    new_single_array << first_array[0][-1]
                    new_array << new_single_array.clone
                    new_single_array = []
                    first_array.shift
                end
                iterator_2 += 1
            elsif first_array[0][iterator_2] === 12 && (first_array[0][iterator_2] + 1 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] - 4 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] - 3 === first_array[0][iterator_2 + 1])
                new_single_array << first_array[0][iterator_2].clone
                if iterator_2 === word_length - 2
                    new_single_array << first_array[0][-1]
                    new_array << new_single_array.clone
                    new_single_array = []
                    first_array.shift
                end
                iterator_2 += 1
            elsif first_array[0][iterator_2] === 15 && (first_array[0][iterator_2] - 1 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] - 4 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] - 5 === first_array[0][iterator_2 + 1])
                new_single_array << first_array[0][iterator_2].clone
                if iterator_2 === word_length - 2
                    new_single_array << first_array[0][-1]
                    new_array << new_single_array.clone
                    new_single_array = []
                    first_array.shift
                end
                iterator_2 += 1
            elsif (first_array[0][iterator_2] === 1 || first_array[0][iterator_2] === 2) && (first_array[0][iterator_2] - 1 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] + 1 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] + 4 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] + 3 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] + 5 === first_array[0][iterator_2 + 1])
                new_single_array << first_array[0][iterator_2].clone
                if iterator_2 === word_length - 2
                    new_single_array << first_array[0][-1]
                    new_array << new_single_array.clone
                    new_single_array = []
                    first_array.shift
                end
                iterator_2 += 1
            elsif (first_array[0][iterator_2] === 4 || first_array[0][iterator_2] === 8) && (first_array[0][iterator_2] - 4 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] + 4 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] + 1 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] - 3 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] + 5 === first_array[0][iterator_2 + 1])
                new_single_array << first_array[0][iterator_2].clone
                if iterator_2 === word_length - 2
                    new_single_array << first_array[0][-1]
                    new_array << new_single_array.clone
                    new_single_array = []
                    first_array.shift
                end
                iterator_2 += 1
            elsif (first_array[0][iterator_2] === 7 || first_array[0][iterator_2] === 11) && (first_array[0][iterator_2] - 4 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] + 4 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] - 1 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] + 3 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] - 5 === first_array[0][iterator_2 + 1])
                new_single_array << first_array[0][iterator_2].clone
                if iterator_2 === word_length - 2
                    new_single_array << first_array[0][-1]
                    new_array << new_single_array.clone
                    new_single_array = []
                    first_array.shift
                end
                iterator_2 += 1
            elsif (first_array[0][iterator_2] === 13 || first_array[0][iterator_2] === 14) && (first_array[0][iterator_2] - 1 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] + 1 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] - 4 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] - 3 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] - 5 === first_array[0][iterator_2 + 1])
                new_single_array << first_array[0][iterator_2].clone
                if iterator_2 === word_length - 2
                    new_single_array << first_array[0][-1]
                    new_array << new_single_array.clone
                    new_single_array = []
                    first_array.shift
                end
                iterator_2 += 1
            elsif (first_array[0][iterator_2] === 5 || first_array[0][iterator_2] === 6 || first_array[0][iterator_2] === 9 || first_array[0][iterator_2] === 10) && (first_array[0][iterator_2] + 1 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] - 1 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] + 4 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] - 4 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] + 3 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] - 3 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] + 5 === first_array[0][iterator_2 + 1] || first_array[0][iterator_2] - 5 === first_array[0][iterator_2 + 1])
                new_single_array << first_array[0][iterator_2].clone
                if iterator_2 === word_length - 2
                    new_single_array << first_array[0][-1]
                    new_array << new_single_array.clone
                    new_single_array = []
                    first_array.shift
                end
                iterator_2 += 1
            else
                first_array.shift
                iterator_2 = word_length
                new_single_array = []
            end
        end
    end
    # if word found match with the input, return true
    if new_array.length >= 1
        puts "\n"
        puts "The word is valid"
        puts "\n"
        return true
    else
        puts "\n"
        puts "The word is invalid"
        puts "\n"
        return false
    end
end

loop(shake(board, dice))