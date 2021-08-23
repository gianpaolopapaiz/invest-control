class PrefixedsController < ApplicationController
  def index
    @portfolio = policy_scope(Portfolio).find(params[:portfolio_id])
    @prefixeds = @portfolio.prefixeds
    if params[:query] && params[:query] != ''
      @query = params[:query]
      @prefixeds = @portfolio.prefixeds.where("short_name ILIKE ? OR description ILIKE ? OR advisor ILIKE ?", "%#{@query}%", "%#{@query}%", "%#{@query}%")
    end
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
    @prefixed.strategy = 'Prefixado'
    if @prefixed.save
      update_prefixeds_price
    else
      render :new
    end
  end

  def edit
    @prefixed = Prefixed.find(params[:id])
    authorize @prefixed
  end

  def update
    @prefixed = Prefixed.find(params[:id])
    authorize @prefixed
      if @prefixed.update(prefixed_params)
        flash[:success] = "Fundos atualizados com sucesso!"
        redirect_to portfolio_prefixeds_path(@prefixed.portfolio)
      else
        flash[:alert] = @prefixed.errors.messages
        render :edit
      end
  end

  def destroy
    fund = Prefixed.find(params[:id])
    authorize fund
    fund.destroy
    redirect_to portfolio_funds_path(fund.portfolio)
  end
  
  def update_prefixeds_price
    if params[:id]
		  portfolio = Portfolio.find(params[:id])
    else
      portfolio = Portfolio.find(params[:portfolio_id])
    end
    authorize portfolio
		if portfolio.prefixeds.length.positive?
      portfolio.prefixeds.each do |prefixed|
        prefixed.actual_price =  prefixed.buy_price + (prefixed.buy_price * prefixed.days_count * (prefixed.day_return / 100))
        prefixed.actual_date = Date.current
        prefixed.save
      end
    end
    redirect_to portfolio_prefixeds_path(portfolio)
  end

  private

  def prefixed_params
    params.require(:prefixed).permit(:buy_date, :buy_quantity, :buy_price, :description, :short_name, :advisor, :end_date, :year_tax)
  end
end
