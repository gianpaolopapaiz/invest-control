class StocksController < ApplicationController
  def fetch_stock
    @portfolio = Portfolio.find(params[:portfolio_id])
  end
  def new
    @short_name = params[:short_name]
    @symbol = params[:symbol]
    @stock = Stock.new
    @portfolio = Portfolio.find(params[:portfolio_id])
  end
  def create
    @portfolio = Portfolio.find(params[:portfolio_id])
    @stock = Stock.new(stock_params)
    # passar stock short name and symbol throught params in the form

  end

  private

  def stock_params
    params.require(:stock).permit(:buy_date, :buy_quantity, :buy_price)
  end
end
