class StocksController < ApplicationController
  def choose_stock
    @portfolio = Portfolio.find(params[:portfolio_id])
    @stock = Stock.new
  end
  def new
    @short_name = params[:short_name]
    @symbol = params[:symbol]
    @stock = Stock.new
    @stock.symbol = @symbol
    @stock.short_name = @short_name
    @portfolio = Portfolio.find(params[:portfolio_id])
  end
  def create
    @portfolio = Portfolio.find(params[:portfolio_id])
    @stock = Stock.new(stock_params)
    @stock.portfolio = @portfolio
    @stock.strategy = 'variable'
    if @stock.save
      redirect_to portfolio_path(@portfolio)
    else
      render :new
    end
  end

  private

  def stock_params
    params.require(:stock).permit(:buy_date, :buy_quantity, :buy_price, :symbol, :short_name)
  end
end
