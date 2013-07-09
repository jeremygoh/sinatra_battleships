require 'sinatra'
require_relative './lib/board.rb'
require_relative './lib/game.rb'
require_relative './lib/player.rb'
require_relative './lib/ship.rb'
require_relative './lib/targetboard.rb'

enable :sessions

@@player_count ||=0 

get '/' do
	erb :index
end

post '/' do
	@@player_count += 1 unless @@player_count ==2
	session[:player_name] = params[:player_name]
	session[:player_number] = 1 if @@player == 1
	session [:player_number] = 2 if @@player == 2
	session[:player_instance] = Player.new
	erb :index
end

get '/reset_game' do
	session.clear
	@@player_count = 0
	redirect '/'
end

get '/place_ships' do
	erb :place_ships
end

post '/place_ships' do
	if session[:player_number] == 1
		#join all input cooridnates for a particular ship and place the ship
		aircraftcarrier_coordinates = [params[:aircraft_coordinate1], params[:aircraft_coordinate2], params[:aircraft_coordinate3], params[:aircraft_coordinate4], params[:aircraft_coordinate5]]
 		#board.place(p2_aircraftcarrier, aircraftcarrier_coordinates )
	elsif session[:player_number] == 2

	else
		"ERROR"
	end
