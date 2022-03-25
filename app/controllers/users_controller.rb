class UsersController < ApplicationController

  def my_portfolio

    @tracked_stocks = current_user.stocks

  end

  def my_friends

    @friends = current_user.friends

  end

  def search

    if params[:friend].present?
      @friend = Stock.new_lookup(params[:friend])

      if @friend
        respond_to do |format|
          format.js{ render partial: 'users/friend_result'}

        end


      else
        respond_to do |format|
          flash.now[:alert]="Please Enter a valid friend name to Search"
            format.js{ render partial: 'users/friend_result'}

          end

      end


    else
      respond_to do |format|
          flash.now[:alert]="Please Enter a friend's name to Search"
            format.js{ render partial: 'users/friend_result'}
          end


    end



  end
  
end
