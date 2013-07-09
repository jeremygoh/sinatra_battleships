class Game


#this method determines who goes first. 1 or 2 and sets it to an instance variable


def finished?
	##something which checks that the status of all ships are not sunk
	$p1.ships.all?{|ship| ship.sunk?} || $p2.ships.all?{|ship| ship.sunk?}
end



def winner
	return "Player 1" if $p2.ships.all?{|ship| ship.sunk?}
	return "Player 2" if $p1.ships.all?{|ship| ship.sunk?}
end


def set_up
	p1_board = Board.new
	p2_board = Board.new
	p1_ships = [AircraftCarrier.new, Battleship.new, Submarine.new, Destroyer.new, PatrolBoat.new]
	p2_ships = [AircraftCarrier.new, Battleship.new, Submarine.new, Destroyer.new, PatrolBoat.new]
	p1_target = p2_board
	p2_target = p1_board
	#made p1 and p2 class variables
	# $p1 = Player.new(p1_board, p1_target, p1_ships)
	# $p2 = Player.new(p2_board, p2_target, p2_ships)
	# puts "P1, place your ships!"
	# puts ""
	# @p1.place_ships
	# puts "*******************************************************"
	# puts "P2, place your ships!"
	# puts ""
	# @p2.place_ships

	[Player.new(p1_board, p1_target, p1_ships), Player.new(p2_board, p2_target, p2_ships)]
end


def who_goes_first
	if rand(1) == 1
		@turn = 1
	else
		@turn =2
	end
	@turn
end



def gameplay

	while !finished?
		if @turn == 1
			puts "P1, it's your turn!"
			puts ""
			puts "The target board looks like this! 1 for hits and 2 for misses"
			puts $p1.target.show_target.inspect
			puts ""
			$p1.shoot
			@turn = 2
		elsif @turn == 2
			puts "P2, it's your turn!"
			puts ""
			puts "The target board looks like this! 1 for hits and 2 for misses"
			puts $p2.target.show_target.inspect
			puts ""
			$p2.shoot
			@turn = 1
		else
			"ERROR"
		end
	end
	puts "The winner is #{winner}!"
	puts "Thanks for playing."
	Process.exit(0)
end

def start
	set_up
	who_goes_first
	gameplay
end

end