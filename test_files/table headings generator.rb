board_grid = [[0, nil, nil, nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]] 

def html_own_board(board_grid)
	board_grid.each do |row|
		print "<tr>"
			row.each do |cell|
				print "<td>"
				if cell== nil
					print " "
				else
					print cell 
				end
				print "</td>"
			end
		print "</tr>"
	end
end

html_own_board(board_grid)
