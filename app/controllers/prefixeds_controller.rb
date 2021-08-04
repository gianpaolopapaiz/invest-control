class PrefixedsController < ApplicationController
  def index
    @portfolio = policy_scope(Portfolio).find(params[:portfolio_id])
    @prefixeds = @portfolio.prefixeds
    # @prefixeds_actual_amount = prefixeds_actual_amount(@prefixeds)
		# @stocks_buy_amount = stocks_buy_amount(@prefixeds)
		
    # if @prefixeds.length > 0 
		# 	@prefixeds_return_tax = ((@prefixeds_actual_amount / @prefixeds_buy_amount) - 1) *100
		# 	@prefixeds_return_value = (@prefixeds_actual_amount - @prefixeds_buy_amount) 
		# end

    # if params[:query] && params[:query] != ''
    #   @query = params[:query]
    #   @prefixeds = @portfolio.prefixeds.where("short_name ILIKE ? OR advisor ILIKE ?", "%#{@query}%", "%#{@query}%")
    # end
  end

  def new
    @prefixed = Prefixed.new
    authorize @prefixed
    @portfolio = Portfolio.find(params[:portfolio_id])
    authorize @portfolio
  end

  def create
    @portfolio = Portfolio.find(params[:portfolio_id])
    authorize @portfolio
    @prefixed = Prefixed.new(prefixed_params)
    @prefixed.portfolio = @portfolio
    @prefixed.strategy = 'Pré-fixado'
    if @prefixed.save
      update_prefixeds_price
    else
      render :new
    end
  end
  
  private

  def update_prefixeds_price
    if params[:id]
		  portfolio = Portfolio.find(params[:id])
    else
      portfolio = Portfolio.find(params[:portfolio_id])
    end
    authorize portfolio
		if portfolio.prefixeds.length.positive?
      portfolio.prefixeds.each do |prefixed|
        prefixed.actual_price =  prefixed.buy_price * prefixed.days_count * prefixed.day_return
        prefixed.actual_date = Date.current
        prefixed.save
      end
    end
    redirect_to portfolio_prefixeds_path(portfolio)
  end

  def prefixed_params
    params.require(:prefixed).permit(:buy_date, :buy_quantity, :buy_price, :description, :short_name, :advisor, :end_date, :year_tax)
  end
end
