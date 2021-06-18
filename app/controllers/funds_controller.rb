class FundsController < ApplicationController
  def choose_fund
    @portfolio = Portfolio.find(params[:portfolio_id])
    @fund = Fund.new
    @query = 'nil'
    if params[:query] && params[:query] != ''
      @query = params[:query]
      @autocomplete = fetch_autocomplete(@query)
      if !@autocomplete
        flash[:alert] = 'API error, please try again later'
      end
    end   
  end

  private

  def fetch_autocomplete(query)
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
