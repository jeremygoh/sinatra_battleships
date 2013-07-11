class Player

attr_accessor :board, :target, :ships

def initialize(board, target_board, ships)
	@board = board
	@target = target_board
	@ships = ships

end

def shoot(coordinate)
	puts "Where would you like to shoot?" #
	@target.shoot(coordinate)
end

def place_ships(allcoordinates)
	allcoordinates = allcoordinates.to_enum
	@ships.each{|ship|
		@board.place(ship, allcoordinates.next)
		}
end

def all_ships_placed?
	flag = true
	@ships.each do |ship|
		if !ship.location_set?
			flag=false
			break
		end
	end
	flag
end



def show_own_board
	@board.grid
end

def html_board(board_grid)
	string= ""
	board_grid.each do |row|
		string += "<tr>"
			row.each do |cell|
				string +="<td>"
				if cell== nil
					string+="**"
				else
					string+= cell.to_s 
				end
				string+= "</td>"
			end
		string+= "</tr>"
	end
	string
end

def show_target_board
	@target.show_target
end


end