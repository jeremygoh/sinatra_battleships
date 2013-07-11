require 'sinatra'
require 'sinatra/flash'
require_relative './lib/board.rb'
require_relative './lib/game.rb'
require_relative './lib/player.rb'
require_relative './lib/ship.rb'
require_relative './lib/targetboard.rb'

enable :sessions

@@player_count ||=0
@@players_who_have_placed_ships = 0 
@@game= Game.new
@@game.set_up
@@game.who_goes_first

$coordinates = ["A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9", "A10", "B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9", "B10", "C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "E1", "E2", "E3", "E4", "E5", "E6", "E7", "E8", "E9", "E10", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "G1", "G2", "G3", "G4", "G5", "G6", "G7", "G8", "G9", "G10", "H1", "H2", "H3", "H4", "H5", "H6", "H7", "H8", "H9", "H10", "I1", "I2", "I3", "I4", "I5", "I6", "I7", "I8", "I9", "I10", "J1", "J2", "J3", "J4", "J5", "J6", "J7", "J8", "J9", "J10"]

before do
	pass if request.path_info == "/" || request.path_info == '/reset_game'
	redirect '/' if !session[:player_name] 
end


get '/' do
	erb :index
end

post '/' do
	@@player_count += 1 unless @@player_count ==2
	session[:player_name] = params[:player_name]
	session[:player_number] = 1 if @@player_count == 1
	session[:player_number] = 2 if @@player_count == 2
	erb :index
end

get '/reset_game' do
	session.clear
	@@player_count = 0
	redirect '/'
	@@game=Game.new
end

get '/place_ships' do
	erb :place_ships
end

post '/place_ships' do
		aircraftcarrier_coordinates = [params[:aircraft_coordinate1], params[:aircraft_coordinate2], params[:aircraft_coordinate3], params[:aircraft_coordinate4], params[:aircraft_coordinate5]]
 		battleship_coordinates = [params[:battleship_coordinate1], params[:battleship_coordinate2], params[:battleship_coordinate3], params[:battleship_coordinate4]]
		submarine_coordinates = [params[:submarine_coordinate1], params[:submarine_coordinate2], params[:submarine_coordinate3]]
		destroyer_coordinates = [params[:destroyer_coordinate1], params[:destroyer_coordinate2], params[:destroyer_coordinate3]]
		patrolboat_coordinates = [params[:patrolboat_coordinate1], params[:patrolboat_coordinate2]]

		coordinates = [aircraftcarrier_coordinates, battleship_coordinates, submarine_coordinates, destroyer_coordinates, patrolboat_coordinates]

		if session[:player_number] == 1
			$p1.place_ships(coordinates)
		elsif session[:player_number] == 2
			$p2.place_ships(coordinates)
		else
			"ERROR"
		end

		if session[:player_number] == 1 && $p1.all_ships_placed?
			@@players_who_have_placed_ships += 1
			redirect '/holding_area'
		elsif session[:player_number] == 2 && $p2.all_ships_placed?
			@@players_who_have_placed_ships += 1
			redirect '/holding_area'
		else
			flash[:placement_message] = "There was a problem with your placement. Check that you have placed your ships logically and within the board."
			##get rid of the above message if it works?
			redirect '/place_ships'
		end		


end

get '/holding_area' do
	erb :holding_area
end

get "/game" do
	erb :game
end

post "/game" do
	if session[:player_number] == 1 
		flash[:shot_status] = $p1.shoot(params[:shoot_coordinate])
		@@game.turn+=1
	elsif session[:player_number] == 2 
		flash[:shot_status] = $p2.shoot(params[:shoot_coordinate])
		@@game.turn+=1	
	end
	redirect "/game"
end

	##if there is some error in setting coordinates, ask for them again
	##otherwise, go to game page

