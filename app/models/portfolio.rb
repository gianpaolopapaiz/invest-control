class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :funds, dependent: :destroy 
  has_many :stocks, dependent: :destroy 
  
  def initial_amount
    sum = 0
    stocks.each do |stock|
      sum += stock.buy_price * stock.buy_quantity
    end
    funds.each do |fund|
      sum += fund.buy_price * fund.buy_quantity
    end
    sum
  end
  def amount
    sum = 0
    stocks.each do |stock|
      sum += stock.actual_price * stock.buy_quantity if stock.actual_price
    end
    funds.each do |fund|
      sum += fund.actual_price * fund.buy_quantity if fund.actual_price
    end
    sum
  end

  def return_value
    sum = 0
    stocks.each do |stock|
      sum += (stock.actual_price - stock.buy_price) * stock.buy_quantity if stock.actual_price
    end
    funds.each do |fund|
      sum += (fund.actual_price - fund.buy_price) * fund.buy_quantity if fund.actual_price
    end
    sum
  end

  def return_tax
    # sum = 0
    # stocks.each do |stock|
    #   sum += (((stock.actual_price / stock.buy_price) -1 ) * 100) if stock.actual_price
    # end
    # funds.each do |fund|
    #   sum += (((fund.actual_price / fund.buy_price) -1 ) * 100) if fund.actual_price
    # end
    # sum
    if amount != 0
      return_value / amount * 100
    else
      0
    end 
  end
end
