class PortfoliosController < ApplicationController
	
	def index
		@portfolios = Portfolio.all
	end

	def show
		@portfolio = Portfolio.find(params[:id])
		update_stocks_price
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

	def update_stocks_price
    portfolio = Portfolio.find(params[:id])
		if portfolio.stocks.length.positive?
			stock_symbols = []
			portfolio.stocks.each_with_index do |stock| 
				stock_symbols << stock.symbol
			end
			query = stock_symbols.join(',')
			data_fetch = fetch_stock_price(query)
			portfolio.stocks.each_with_index do |stock, index| 
				stock.actual_price = data_fetch['quoteResponse']['result'][index]['regularMarketPrice']
				stock.actual_date = DateTime.now
				stock.save
			end
		end
  end

	def fetch_stock_price(query)
    url = URI("https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/v2/get-quotes?region=BR&symbols=#{query}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = ENV["YAHOO_API"]
    request["x-rapidapi-host"] = 'apidojo-yahoo-finance-v1.p.rapidapi.com'
    response = http.request(request)
    return JSON.parse(response.read_body)
  end
	
	def portfolio_params
		params.require(:portfolio).permit(:name)
	end
	
end
