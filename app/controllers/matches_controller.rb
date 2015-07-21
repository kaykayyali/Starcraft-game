class MatchesController < ApplicationController

  def index

    matches = Match.all

    render :json => matches

  end

  def get_player

    player = Player.find_by(:id => params[:player])
    matches = Match.where("winner_id = " + player.id.to_s + " OR loser_id = " + player.id.to_s)
    win_percentage = playerPercentageMaker(player.id, matches)
    loss_percentage = (100.0 - win_percentage).to_s + "%"
    win_percentage = win_percentage.to_s + "%"
    render :json =>{
    	:percentages => {
    				:wins => win_percentage,
    				:losses => loss_percentage
    				},
    	:matches => matches		
   		 }
  end

  def get_faction

    matches = Match.where(" winner_faction = ? OR loser_faction = ?",  params[:faction], params[:faction])
    percentage = factionPercentageMaker(params[:faction], matches)
    render :json => {
    	:win_percentage => percentage,
    	:matches => matches
    		
    	}
  end
  private
  def factionPercentageMaker(faction,matches_array)
		

		wins = 0
		losses = 0

		matches_array.each do |match|
			if match.winner_faction == faction
				wins = wins + 1
			else
				losses = losses + 1
			end
		end
		percentage = (wins.to_f / matches_array.count.to_f) * 100
		return percentage.to_s + "%"
	end

	  def playerPercentageMaker(player_id,matches_array)
		

		wins = 0
		losses = 0

		matches_array.each do |match|
			if match.winner_id == player_id
				wins = wins + 1
			else
				losses = losses + 1
			end
		end
		percentage = (wins.to_f / matches_array.count.to_f) * 100
		return percentage
	end
end
