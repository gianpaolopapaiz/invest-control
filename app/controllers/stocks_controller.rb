class StocksController < ApplicationController
  def index
    @portfolio = Portfolio.find(params[:portfolio_id])
    @stocks = @portfolio.stocks
    @stocks_actual_amount = stocks_actual_amount(@stocks)
		@stocks_buy_amount = stocks_buy_amount(@stocks)
		
    if @stocks.length > 0 
			@stocks_return_tax = ((@stocks_actual_amount / @stocks_buy_amount) - 1) *100
			@stocks_return_value = (@stocks_actual_amount - @stocks_buy_amount) 
		end

    if params[:query] && params[:query] != ''
      @query = params[:query]
      @stocks = @portfolio.stocks.where("symbol ILIKE ? OR advisor ILIKE ?", "%#{@query}%", "%#{@query}%")
    end
    
  end
  
  def choose_stock
    @portfolio = Portfolio.find(params[:portfolio_id])
    @stock = Stock.new
    @query = 'nil'
    if params[:query] && params[:query] != ''
      @query = params[:query]
      @autocomplete = fetch_autocomplete(@query)['quotes']
      if !@autocomplete
        flash[:alert] = 'API error, please try again later'
      end
    end
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

  def edit
    @stock = Stock.find(params[:id])
  end

  def update
    @stock = Stock.find(params[:id])
      if @stock.update(stock_params)
        flash[:success] = "Stock successfully updated"
        redirect_to portfolio_path(@stock.portfolio)
      else
        flash[:alert] = @stock.errors.messages
        render :edit
      end
  end

  def destroy
    stock = Stock.find(params[:id])
    stock.destroy
    redirect_to portfolio_path(stock.portfolio)
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
			if data_fetch['quoteResponse']
				portfolio.stocks.each_with_index do |stock, index| 
					stock.actual_price = data_fetch['quoteResponse']['result'][index]['regularMarketPrice']
					stock.actual_date = DateTime.now
					if stock.save
						flash[:alert] = 'Stocks updated'
					else
						flash[:alert] = stock.errors.messages
					end
				end
			else
				flash[:alert] = 'API error, please try again later'
			end
			redirect_to portfolio_stocks_path(portfolio)
		end
	end

  private

  def stocks_actual_amount(stocks)
		sum = 0
		@stocks.each do |stock|
			sum += (stock.buy_quantity * stock.actual_price) if stock.actual_price
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

  def fetch_autocomplete(query)
    url = URI("https://apidojo-yahoo-finance-v1.p.rapidapi.com/auto-complete?q=#{query}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = ENV["YAHOO_API"]
    request["x-rapidapi-host"] = 'apidojo-yahoo-finance-v1.p.rapidapi.com'
    response = http.request(request)
    return JSON.parse(response.read_body)
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

  def stock_params
    params.require(:stock).permit(:buy_date, :buy_quantity, :buy_price, :symbol, :short_name, :advisor)
  end
end
