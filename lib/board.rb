class Board
attr_accessor :occupied, :misses, :hits

###letters are columns
##Numbers are rows

	def initialize
		@grid = Array.new(10) {Array.new(10)}	##need to change this
		@ships = []
		@occupied = []
		@misses=[]
		@hits = []
	end

	def occupied
		@occupied
	end

	def ships
		@ships
	end

	def grid #this will show empty cells with nil, occupied as 0, hit occupied as 1. 
		@grid
	end

	#######
	def show_target	
		@target = @grid.map {|line| line.dup}
		replace_occupied(apply_misses)
	end

	def apply_misses
		coordinates_in_numbers = convert_to_numbers(self.misses)
		coordinates_in_numbers.each {|coordinate|
			@target[convert_row_number_to_index(coordinate)][coordinate[0].to_i-1] = 2
		}
		@target	
	end

	

	def replace_occupied(board_with_misses)
		board_without_occupied = board_with_misses.map{|row|
			row.map{|cell| 
			cell==0 ? nil: cell
			}
		}
	end







#########
	def shoot(coordinate)
		if !shoot_coordinate_ok?(coordinate)
			puts "That shot was so bad, you missed the board! Invalid coordinate."
		elsif @misses.include?(coordinate) || @hits.include?(coordinate)
			puts "No change. You already targeted that square!"
		elsif @occupied.include?(coordinate)
			@hits << coordinate
			ship = ship_in_coordinate(coordinate)
			ship.hit!
			change_coordinate_to_hit([coordinate])
			if !ship.sunk?
				puts "HIT"
			else
				puts "Sunk a ship!"
			end
		else
			@misses << coordinate
			puts "MISS!"
			puts ""
		end
	end


	def change_coordinate_to_hit(coordinates)	###change it so 0 indicates occupied, nil is empty, 1 is hit
		coordinates_in_numbers = convert_to_numbers(coordinates)	##returns [11,12,13]
		coordinates_in_numbers.each {|coordinate|
			@grid[convert_row_number_to_index(coordinate)][coordinate[0].to_i-1] = 1
		}
	end


	def ship_in_coordinate(coordinate)
		what_ship = "no ship"
		@ships.each{|ship|
			if ship.location.include?(coordinate)
				what_ship = ship
				break
			end
		}
		what_ship
	end

	
	def place(ship, coordinates)
			if coordinates_ok?(ship, coordinates)
				ship.set_location!(coordinates)
				@ships << ship
				coordinates.each{|coordinate|
					@occupied << coordinate
				}
				apply_coordinates_to_grid(coordinates)
			else
				puts "Problem setting coordinates. There are either insufficient coordinates, they are invalid or are already occupied!"
			end
	end



	def convert_row_number_to_index(coordinate)
		(coordinate[1,2].to_i - 1)
	end

	def apply_coordinates_to_grid(coordinates)	###change it so 0 indicates occupied, nil is empty, 1 is hit
		coordinates_in_numbers = convert_to_numbers(coordinates)	##returns [11,12,13]
		coordinates_in_numbers.each {|coordinate|
			@grid[convert_row_number_to_index(coordinate)][coordinate[0].to_i-1] = 0
		}
	end

##for a single coordinate

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

	########start of coordinate checks##########

	def valid?(coordinates) ##this will need to check if the placement of coorindates is valid, sequential in row/number
		horizontal_valid?(coordinates) || vertical_valid?(coordinates)
	end

	def vertical_valid?(coordinates)
		same_letter?(coordinates) && sequential_numbers?(coordinates)
	end

	def same_letter?(coordinates)
		letters=[]
		coordinates.each{|coordinate|
			letters << coordinate[0]}
		letters.uniq.size == 1
	end

	def sequential_numbers?(coordinates)
		numbers = "012345678910"
		numbers_from_coordinates = ""
		coordinates.each{|coordinate| 
			numbers_from_coordinates += coordinate[1,2]
				}

		numbers.include?(numbers_from_coordinates)
	end


	def horizontal_valid?(coordinates)
		sequential_letters?(coordinates) && same_number?(coordinates)
	end

	def same_number?(coordinates)
		allnumbers = []
		coordinates.each{|coordinate|
			allnumbers << coordinate[1,2]}
		allnumbers.uniq.size == 1
	end

	def sequential_letters?(coordinates)
		letters = "ABCDEFGHIJ"
		letters_from_coordinates = ""
		coordinates.each{|coordinate| 
			letters_from_coordinates += coordinate[0]
				}

		letters.include?(letters_from_coordinates)
	end



	def in_range?(coordinates)
		flag=true
		possible = ["A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9", "A10", "B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9", "B10", "C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "E1", "E2", "E3", "E4", "E5", "E6", "E7", "E8", "E9", "E10", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "G1", "G2", "G3", "G4", "G5", "G6", "G7", "G8", "G9", "G10", "H1", "H2", "H3", "H4", "H5", "H6", "H7", "H8", "H9", "H10", "I1", "I2", "I3", "I4", "I5", "I6", "I7", "I8", "I9", "I10", "J1", "J2", "J3", "J4", "J5", "J6", "J7", "J8", "J9", "J10"]
		coordinates.each{|coordinate|
		if !possible.include?(coordinate)
			flag=false
			break
		end
		 }
		flag
	end


	def size?(ship, coordinates)
		ship.length == coordinates.size
	end

	def occupied?(coordinates)
		flag = false
		coordinates.each{|coordinate|
		if @occupied.include?(coordinate)
			flag = true; break
		end
		}
		flag
	end


	def coordinates_ok?(ship, coordinates)
		size?(ship, coordinates) && in_range?(coordinates) && !occupied?(coordinates) && valid?(coordinates)
	end

	def shoot_coordinate_ok?(coordinate)
		in_range?([coordinate])
	end

	######end of coordinate checks########

end


