class FundsController < ApplicationController
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
    raise
    @short_name = params[:short_name]
    @cnpj = params[:cnpj]
    @stock = Stock.new
    @stock.symbol = @symbol
    @stock.short_name = @short_name
    @portfolio = Portfolio.find(params[:portfolio_id])
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
end
