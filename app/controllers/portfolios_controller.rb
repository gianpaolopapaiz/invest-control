class PortfoliosController < ApplicationController
	
	def index
		@portfolios = Portfolio.all
	end

	def show
		@portfolio = Portfolio.find(params[:id])
		@stocks = @portfolio.stocks
		@stocks_actual_amount = stocks_actual_amount(@stocks)
		@stocks_buy_amount = stocks_buy_amount(@stocks)
		if @stocks.length > 0 
			@stocks_return_tax = ((@stocks_actual_amount / @stocks_buy_amount) - 1) *100
			@stocks_return_value = (@stocks_actual_amount - @stocks_buy_amount) 
		end
	end

	def new
		@portfolio = Portfolio.new
	end

	def create
		@portfolio = Portfolio.new(portfolio_params)
		if @portfolio.save
			redirect_to portfolio_path(@portfolio)
		else
			render :new
		end
	end

	private

	def stocks_actual_amount(stocks)
		sum = 0
		@stocks.each do |stock|
			sum += (stock.buy_quantity * stock.actual_price)
		end
		sum
	end

	def stocks_buy_amount(stocks)
		sum = 0
		@stocks.each do |stock|
			sum += (stock.buy_quantity * stock.buy_price)
		end
		sum
	end
	
	def portfolio_params
		params.require(:portfolio).permit(:name)
	end
	
end
