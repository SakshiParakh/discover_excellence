class PlayersController < ApplicationController

  def new
    if(params[:game_id])
      @game = Game.find(params[:game_id])
      @tournament = Tournament.find_by(game_id: params[:game_id], id: params[:tournament_id])
      @match = Match.find_by(game_id: params[:game_id], id: params[:match_id])
    end
    @player = Player.new
  end

  def index
    if(params[:tournament_id])
      @game = Game.find(params[:game_id])
      @tournament = Tournament.find_by(game_id: params[:game_id], id: params[:tournament_id])
      @match = Match.find_by(game_id: params[:game_id], tournament_id: params[:tournament_id], id: params[:match_id])
      @player_list = @match.players
    elsif(params[:match_id] && !params[:tournament_id])
      @game = Game.find(params[:game_id])
      @match = Match.find_by(game_id: params[:game_id], id: params[:match_id])
      @player_list = @match.players
    else 
      @player_list = Player.all
    end
  end

  def create
    if(params[:game_id])
      @game = Game.find(params[:game_id])
      @tournament = Tournament.find_by(game_id: params[:game_id], id: params[:tournament_id])
      @match = Match.find_by(game_id: params[:game_id], id: params[:match_id])
    end
    if(params[:tournament_id])
      @match = Match.find_by(game_id: params[:game_id], tournament_id: params[:tournament_id], id: params[:match_id])
    end

    @player = Player.new(allowed_params)
    @player.user_id = current_user.id
    #@player.game_list.push allowed_params[:game_list]
    if @player.save
      Score.create(player_id: @player.id, match_id: params[:match_id])
      flash[:notice] = "Created Successfully"
      if(params[:tournament_id])
        redirect_to game_tournament_match_players_path(@game, @tournament, @match)
      elsif(params[:match_id] && !params[:tournament_id])
        redirect_to game_match_players_path(@game,@match)
      else
        redirect_to players_path(@game)
      end
    else
      render :new
    end
  end

  def show
    @player_details = Player.find(params[:id])
  end

  def edit
    if(params[:game_id])
      @game = Game.find(params[:game_id])
      @tournament = Tournament.find_by(game_id: params[:game_id], id: params[:tournament_id])
      @match = Match.find_by(game_id: params[:game_id], id: params[:match_id])
    end
      @player_edit = Player.find(params[:id])
  end

  def update
    if(params[:game_id])
      @game = Game.find(params[:game_id])
      @match = Match.find_by(game_id: params[:game_id], id: params[:match_id])
      @tournament = Tournament.find_by(game_id: params[:game_id], id: params[:tournament_id])
    end
    @player_edit = Player.find(params[:id])
    if @player_edit.update_attributes(allowed_params)
      flash[:notice] = "Updated Successfully"
      if (params[:tournament_id])
        redirect_to game_tournament_match_players_path(@game, @tournament, @match)
      elsif (params[:match_id] && !params[:tournament_id])
        redirect_to game_match_players_path(@game,@match)
      else
        redirect_to players_path(@game)
      end
    else
      render :edit
    end
  end

  def destroy
    @player_delete = Player.destroy(params[:id])
  end

  def allowed_params
    params.require(:player).permit!()
  end

end

