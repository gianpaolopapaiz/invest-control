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
    if amount != 0
      return_value / initial_amount * 100
    else
      0
    end 
  end

  def strategy_composition
    composition = {}
    if amount != 0
      stocks.each do |stock|
        if composition["#{stock.strategy}"]
          composition["#{stock.strategy}"] += stock.amount / amount * 100
        else
          composition["#{stock.strategy}"] = stock.amount / amount * 100
        end
      end
      funds.each do |fund|
        if composition["#{fund.strategy}"]
          composition["#{fund.strategy}"] += fund.amount / amount * 100
        else
          composition["#{fund.strategy}"] = fund.amount / amount * 100
        end
      end
    end
    composition
  end

  def strategy_composition_value
    composition = {}
    if amount != 0
      stocks.each do |stock|
        if composition["#{stock.strategy}"]
          composition["#{stock.strategy}"] += stock.amount
        else
          composition["#{stock.strategy}"] = stock.amount
        end
      end
      funds.each do |fund|
        if composition["#{fund.strategy}"]
          composition["#{fund.strategy}"] += fund.amount
        else
          composition["#{fund.strategy}"] = fund.amount
        end
      end
    end
    composition
  end

  def initial_date
    stock_date = stocks.order(:buy_date).first.buy_date
    fund_date = funds.order(:buy_date).first.buy_date
    if stock_date && fund_date
      stock_date < fund_date ? stock_date : fund_date
    elsif stock_date && !fund_date
      stock_date
    elsif !stock_date && fund_date
      fund_date
    else
      nil
    end
  end

  def finish_date
    stock_date = stocks.order(:actual_date).last.actual_date
    fund_date = funds.order(:actual_date).last.actual_date
    if stock_date && fund_date
      stock_date > fund_date ? stock_date : fund_date
    elsif stock_date && !fund_date
      stock_date
    elsif !stock_date && fund_date
      fund_date
    else
      nil
    end
  end

  def cdi_tax 
    date_start = initial_date
    date_end = finish_date
    if date_start && date_end
      Cdi.where("date_tax >= '#{date_start}' AND date_tax <= '#{date_end}'").sum(:value_day) * 100
    else
      0
    end
  end
end

