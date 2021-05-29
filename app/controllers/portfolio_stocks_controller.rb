class PortfolioStocksController < ApplicationController
  def new
    @portfolio_stock = PortfolioStock.new
  end
  
end
