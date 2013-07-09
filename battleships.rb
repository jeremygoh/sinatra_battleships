require 'sinatra'
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
			session[:message] = "There was a problem with your placement. Check that you have placed your ships logically and within the board."
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
		session[:message1] = $p1.shoot(params[:shoot_coordinate])
		@@game.turn+=1
	elsif session[:player_number] == 2 
		session[:message1] = $p2.shoot(params[:shoot_coordinate])
		@@game.turn+=1	
	end
	redirect "/game"
end

	##if there is some error in setting coordinates, ask for them again
	##otherwise, go to game page

