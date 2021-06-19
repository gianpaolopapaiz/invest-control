class PortfoliosController < ApplicationController
	
	def index
		@portfolios = Portfolio.all
	end

	def show
		@portfolio = Portfolio.find(params[:id])
		# stocks
		@stocks = @portfolio.stocks
		@stocks_actual_amount = product_actual_amount(@stocks)
		@stocks_buy_amount = product_buy_amount(@stocks)
		if @stocks.length > 0 
			if @stocks_actual_amount != 0
				@stocks_return_tax = ((@stocks_actual_amount / @stocks_buy_amount) - 1) *100
				@stocks_return_value = (@stocks_actual_amount - @stocks_buy_amount)
			else
				@stocks_return_tax = 0
				@stocks_return_value = 0
			end 
		end
		# funds
		@funds = @portfolio.funds
		@funds_actual_amount = product_actual_amount(@funds)
		@funds_buy_amount = product_buy_amount(@funds)
		if @funds.length > 0 
			if @funds_actual_amount != 0
				@funds_return_tax = ((@funds_actual_amount / @funds_buy_amount) - 1) *100
				@funds_return_value = (@funds_actual_amount - @funds_buy_amount)
			else
				@funds_return_tax = 0
				@funds_return_value = 0
			end
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

	def product_actual_amount(product)
		sum = 0
		product.each do |product|
			sum += (product.buy_quantity * product.actual_price) if product.actual_price 
		end
		sum
	end

	def product_buy_amount(product)
		sum = 0
		product.each do |product|
			sum += (product.buy_quantity * product.buy_price)
		end
		sum
	end
	
	def portfolio_params
		params.require(:portfolio).permit(:name)
	end
	
end
