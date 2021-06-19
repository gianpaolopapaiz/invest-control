class FundsController < ApplicationController
  def index
    @portfolio = Portfolio.find(params[:portfolio_id])
    @funds = @portfolio.funds
    # @funds_actual_amount = stocks_actual_amount(@stocks)
		# @funds_buy_amount = stocks_buy_amount(@stocks)
		# if @funds.length > 0 
		# 	@funds_return_tax = ((@funds_actual_amount / @funds_buy_amount) - 1) *100
		# 	@funds_return_value = (@funds_actual_amount - @funds_buy_amount) 
		# end

    # if params[:query] && params[:query] != ''
    #   @query = params[:query]
    #   @stocks = @portfolio.stocks.where("symbol ILIKE ? OR advisor ILIKE ?", "%#{@query}%", "%#{@query}%")
    # end
    
  end
  
  def choose_fund
    @portfolio = Portfolio.find(params[:portfolio_id])
    @fund = Fund.new
    @query = 'nil'
    if params[:query] && params[:query] != ''
      @query = params[:query]
      @fetched_fund = fetch_fund(@query)
      if !@fetched_fund
        flash[:alert] = 'API error, please try again later'
      end
    end   
  end

  def new
    @short_name = params[:short_name]
    @cnpj = params[:cnpj]
    @cnpj_clean = params[:cnpj_clean]
    @fund_class = params[:fund_class]
    @fund = Fund.new
    @fund.cnpj = @cnpj
    @fund.cnpj_clean = @cnpj_clean
    @fund.fund_class = @fund_class
    @fund.short_name = @short_name
    @portfolio = Portfolio.find(params[:portfolio_id])
  end

  def create
    @portfolio = Portfolio.find(params[:portfolio_id])
    @fund = Fund.new(fund_params)
    @fund.portfolio = @portfolio
    if @fund.save
      redirect_to portfolio_path(@portfolio)
    else
      render :new
    end
  end

  private

  def fetch_fund(query)
    token = get_financial_data_token
    if token
      uri = URI.parse("https://api.financialdata.io/v1/fundos/#{query}")
      header = {'Content-Type': 'application/json', 'Authorization': "Bearer #{token}"}
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri, header)
      response = http.request(request)
      return JSON.parse(response.read_body) 
    else
      flash[:alert] = 'Error to retrieve token'
      render :choose_fund
    end
  end

  def get_financial_data_token
    login = ENV["FINANCIAL_LOGIN"]
    password = ENV["FINANCIAL_PASSWORD"]
    uri = URI.parse('https://api.financialdata.io/v1/token')
    header = {'Content-Type': 'application/json'}
    body = {usuario: login, senha: password}
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = body.to_json
    response = http.request(request)
    return response.read_body
  end

  def fund_params
    params.require(:fund).permit(:buy_date, :buy_quantity, :buy_price, :cnpj, :cnpj_clean, :short_name, :advisor, :fund_class, :strategy)
  end
end
