class Api::V1::StocksController < Api::V1::BaseController
  def index
    @stocks = Stock.all 
  end

  def show
    @stock = Stock.find(params[:id])
  end

 end