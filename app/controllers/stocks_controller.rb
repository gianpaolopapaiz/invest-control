class StocksController < ApplicationController
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
        flash[:success] = "Stock was successfully updated"
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

  private

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

  def stock_params
    params.require(:stock).permit(:buy_date, :buy_quantity, :buy_price, :symbol, :short_name, :advisor)
  end
end
