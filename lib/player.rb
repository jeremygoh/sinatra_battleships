class Player

attr_accessor :board, :target, :ships

def initialize(board, target_board, ships)
	@board = board
	@target = target_board
	@ships = ships

end

def shoot
	puts "Where would you like to shoot?" #
	coordinate = gets.chomp
	@target.shoot(coordinate)
end

def place_ships
	@ships.each{|ship|
		while !ship.location_set?
		puts @board.grid.inspect
		puts ""
		puts "Where would you like to play your #{ship.class} of length #{ship.length}?" 
		puts "Inputs format is A1,A2,A3 etc."
		puts ""
		coordinates = gets.chomp.split(",").to_a
		@board.place(ship, coordinates)
		end
		}
	
end



def show_own_board
	@board.grid
end

def show_target_board
	@target.show_target
end


end