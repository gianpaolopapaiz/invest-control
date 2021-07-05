class PortfoliosController < ApplicationController
	
	def index
		@portfolios = policy_scope(Portfolio).order(created_at: :desc)
	end

	def show
		@portfolio = Portfolio.find(params[:id])
		authorize @portfolio
		@stocks = @portfolio.stocks
		@funds = @portfolio.funds
		#portfolio
		@portfolio_actual_amount = portfolio_actual_amount
		@portfolio_buy_amount = portfolio_buy_amount
		if @stocks.length > 0 || @funds.length > 0
			@portfolio_return_tax = ((@portfolio_actual_amount / @portfolio_buy_amount) - 1) *100
			@portfolio_return_value = (@portfolio_actual_amount - @portfolio_buy_amount)
		else
			@portfolio_return_tax = 0
			@portfolio_return_value = 0
		end
		# stocks
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
		authorize @portfolio
	end

	def create
		@portfolio = Portfolio.new(portfolio_params)
		authorize @portfolio
		@portfolio.user = current_user
		if @portfolio.save
			redirect_to portfolios_path
		else
			flash[:alert] = @portfolio.errors.messages
			render :new
		end
	end

	def edit
		@portfolio = Portfolio.find(params[:id])
		authorize @portfolio
	end

	def update
		@portfolio = Portfolio.find(params[:id])
		authorize @portfolio
			if @portfolio.update(portfolio_params)
				flash[:success] = "Portfolio was successfully updated"
				redirect_to portfolios_path
			else
				flash[:error] = "Something went wrong"
				render :edit
			end
	end
	

	def destroy
		@portfolio = Portfolio.find(params[:id])
		authorize @portfolio
		@portfolio.destroy
		redirect_to portfolios_path
	end

	private

	def portfolio_actual_amount
		portfolio = Portfolio.find(params[:id])
		sum = 0
		sum = product_actual_amount(portfolio.stocks) if portfolio.stocks.length > 0
		sum += product_actual_amount(portfolio.funds) if portfolio.funds.length > 0
		sum
	end

	def portfolio_buy_amount
		portfolio = Portfolio.find(params[:id])
		sum = 0
		sum = product_buy_amount(portfolio.stocks) if portfolio.stocks.length > 0
		sum += product_buy_amount(portfolio.funds) if portfolio.funds.length > 0
		sum
	end
	
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
