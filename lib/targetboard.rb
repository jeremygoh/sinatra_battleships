class TargetBoard

	attr_accessor :grid

	def initialize(board)
		@target = board.dup
	#this method will show the grid of the board with misses and without the 1s
end

	def show(board)	
		replace_occupied(apply_misses(board))
	end

	def apply_misses(board)	
		targetboard = board.grid.map {|line| line.dup}	##why does this work?!
		coordinates_in_numbers = convert_to_numbers(board.misses)
		coordinates_in_numbers.each {|coordinate|
			targetboard[convert_row_number_to_index(coordinate)][coordinate[0].to_i-1] = 2
		}
		targetboard
	end

	

	def replace_occupied(board_with_misses)
		board_without_occupied = board_with_misses.map{|row|
			row.map{|cell| 
			cell==1 ? nil: cell
			}
		}
	end


		def convert_row_number_to_index(coordinate)
		(coordinate[1,2].to_i - 1)
		end


	def convert_to_numbers(coordinates)
		coordinates_in_numbers = []
		coordinates.each{|coordinate|
			coordinates_in_numbers << (convert_letter_to_number(coordinate[0]) + coordinate[1,2])
		}
		coordinates_in_numbers
	end

	def convert_letter_to_number(letter)
		case letter
			when "A" then "1"
			when "B" then "2"
			when "C" then "3"
			when "D" then "4"
			when "E" then "5"
			when "F" then "6"
			when "G" then "7"
			when "H" then "8"
			when "I" then "9"
			when "J" then "10"	
		end
	end


end