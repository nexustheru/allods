class CharactersController < ApplicationController
  has_widgets do |root|
    root << widget('loot_status_widgets/container',
                    "loot_status_container_#{@character.id}",
                    :character_id => @character.id)
  end

  before_filter :authenticate_user!,  :except => [:index, :show]

  # @get
  #
  def index
    if user_signed_in?
      @own_characters = Character.for current_user
      @characters = Character.for_everyone_but current_user
    else
      @own_characters = []
      @characters = Character.all
    end
  end

  # @get
  #
  def new
    @character = Character.new
  end

  # @post
  #
  def create
    @character = Character.new(params[:character])
    @character.user = current_user

    respond_to do |format|
      if @character.save
        format.html { redirect_to character_url(@character.reload), :notice => :created! }
        format.json { render :json => @character, :status => :created, :location => character_url(@character) }
      else
        render_errors(format, @character.errors)
      end
    end
  end

  # @get
  #
  def show
    @character = Character.find(params[:id])
    title! :nickname => @character.nickname

    respond_to do |format|
      format.html
      format.json { render :json => @character }
    end
  end

  # @get
  #
  def edit
    @character = Character.find(params[:id])
    title! :nickname => @character.nickname
  end

  # @put
  #
  def update
    @character = Character.find(params[:id])

    # smart JS require to extract the role from the proper radio buttons values set
    params[:character][:role] = params.find { |k,v| k =~ /roles_group_for_#{params[:character][:archetype]}/ }.last

    respond_to do |format|
      if @character.update_attributes(params[:character])
        format.html { redirect_to character_url(@character), :notice => updated! }
        format.json { rende  :json => @character, :status => :ok }
      else
        render_errors(format, @character.errors)
      end
    end
  end

  #def current_loot_statuses
    #return nil unless user_signed_in?
    #if params[:loot_machine_id]
      #[ LootStatus.where(:user_id => current_user.id, :loot_machine_id => params[:loot_machine_id]) ]
    #elsif params[:loot_status_id]
      #[ LootStatus.find(params[:loot_status_id]) ]
    #elsif @character
      #LootStatus.where(:user_id => @character.id)
    #end
  #end
end
