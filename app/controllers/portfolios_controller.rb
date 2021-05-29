class PortfoliosController < ApplicationController
	
	def index
		@portfolios = Portfolio.all
	end

	def show
		@portfolio = Portfolio.find(params[:id])
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

	def portfolio_params
		params.require(:portfolio).permit(:name)
	end
	
end
