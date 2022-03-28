class User < ApplicationRecord

  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable



  def stock_already_tracked?(ticker_symbol)   #->first two line checking case for if stock already exists in stock table or not?
                                          #-> and third line checking case for if stock is tracked by user or not.

    stock = Stock.check_db(ticker_symbol)
    return false unless stock   #->The False is written if stock => nill.


    stocks.where(id: stock.id).exists?        #->this comes from console query =>u.stocks.where(id: 9).exists?

  end


  def under_stock_limit?

    stocks.count < 10   #-> you can write .stocks.count inplace of user.stocks.count since it is in User model.

  end


  def can_track_stock?(ticker_symbol)
 
    under_stock_limit?  && !stock_already_tracked?(ticker_symbol)


  end


  def full_name

    return "#{first_name} #{last_name}" if first_name || last_name
    "Anonymous"

  end

  def self.search(param)

    param.strip!
    to_send_back = (first_name_matches(param) + (last_name_matches(param)) + email_matches(param)).uniq
    return nil unless to_send_back
    to_send_back

  end

  def self.first_name_matches(param)

    matches('first_name',param)

  end



  def self.last_name_matches(param)

    matches('last_name',param)

  end


  def self.email_matches(param)

    matches('email',param)

  end

  def self.matches(field_name, param)

    where("#{field_name} like ?","%#{param}%")

  end


  def except_current_user(users)

    users.reject{ |user| user.id == self.id}

  end

  def not_friends_with?(id_of_friend)

    !self.friends.where(id: id_of_friend).exists?

  end


end



    
