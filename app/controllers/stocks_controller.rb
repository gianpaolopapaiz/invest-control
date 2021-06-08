class StocksController < ApplicationController
  def choose_stock
    @portfolio = Portfolio.find(params[:portfolio_id])
    @stock = Stock.new
    @query = 'nil'
    if params[:query] && params[:query] != ''
      @query = params[:query]
      @autocomplete = fetch_autocomplete(@query)['quotes']
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

  private

  def fetch_autocomplete(query)
    url = URI("https://apidojo-yahoo-finance-v1.p.rapidapi.com/auto-complete?q=#{@query}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = '0d23aa15ccmsh08742d5ddc98f33p18f9dbjsnd790f2c04382'
    request["x-rapidapi-host"] = 'apidojo-yahoo-finance-v1.p.rapidapi.com'
    response = http.request(request)
    return JSON.parse(response.read_body)
  end

  def stock_params
    params.require(:stock).permit(:buy_date, :buy_quantity, :buy_price, :symbol, :short_name)
  end
end
