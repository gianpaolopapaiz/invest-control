class FundsController < ApplicationController
  def choose_fund
    @portfolio = Portfolio.find(params[:portfolio_id])
    @fund = Fund.new
    @query = 'nil'
    if params[:query] && params[:query] != ''
      @query = params[:query]
      @autocomplete = fetch_autocomplete(@query)['quotes']
      if !@autocomplete
        flash[:alert] = 'API error, please try again later'
      end
    end   
  end

  private

  def fetch_autocomplete(query)
    get_financial_data_token
  end

  def get_financial_data_token
    login = ENV["FINANCIAL_DATA_LOGIN"]
    password = ENV["FINANCIAL_DATA_PASSWORD"]
    
  end
end
