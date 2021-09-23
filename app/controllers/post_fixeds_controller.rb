class PostFixedsController < ApplicationController
  def index
    @portfolio = policy_scope(Portfolio).find(params[:portfolio_id])
    @post_fixeds = @portfolio.post_fixeds
    if params[:query] && params[:query] != ''
      @query = params[:query]
      @post_fixeds = @portfolio.post_fixeds.where("short_name ILIKE ? OR description ILIKE ? OR advisor ILIKE ?", "%#{@query}%", "%#{@query}%", "%#{@query}%")
    end
  end
  
  def new
    @post_fixed = PostFixed.new
    authorize @post_fixed
    @portfolio = Portfolio.find(params[:portfolio_id])
    authorize @portfolio
  end

  def create
    @portfolio = Portfolio.find(params[:portfolio_id])
    authorize @portfolio
    @post_fixed = PostFixed.new(post_fixed_params)
    @post_fixed.portfolio = @portfolio
    @post_fixed.strategy = 'Pós-fixado'
    if @post_fixed.save
      update_post_fixeds_price
    else
      render :new
    end
  end

  def edit
    @post_fixed = PostFixed.find(params[:id])
    authorize @post_fixed
  end

  def update
    @post_fixed = PostFixed.find(params[:id])
    authorize @post_fixed
      if @post_fixed.update(post_fixed_params)
        flash[:success] = "Fundos atualizados com sucesso!"
        redirect_to portfolio_post_fixeds_path(@post_fixed.portfolio)
      else
        flash[:alert] = @post_fixed.errors.messages
        render :edit
      end
  end

  def destroy
    post_fixed = PostFixed.find(params[:id])
    authorize post_fixed
    post_fixed.destroy
    redirect_to portfolio_post_fixeds_path(post_fixed.portfolio)
  end

  def update_post_fixeds_price
    if params[:id]
		  portfolio = Portfolio.find(params[:id])
    else
      portfolio = Portfolio.find(params[:portfolio_id])
    end
    authorize portfolio
		if portfolio.post_fixeds.length.positive?
      portfolio.post_fixeds.each do |post_fixed|
        sum = 0
        if post_fixed.tax_index === 'CDI'
          sum = Cdi.where("date_tax >= '#{post_fixed.buy_date}' AND date_tax <= '#{Date.current}'").sum(:value_day)
        elsif post_fixed.tax_index === 'IPCA'
          sum = Ipca.where("date_tax >= '#{post_fixed.buy_date}' AND date_tax <= '#{Date.current}'").sum(:value_day)
        end
        post_fixed.actual_price = (sum * (post_fixed.rate_index / 100) + 1) * post_fixed.buy_price
        post_fixed.actual_date = Date.current
        post_fixed.save
      end
    end
    redirect_to portfolio_post_fixeds_path(portfolio)
  end

  private

  def post_fixed_params
    params.require(:post_fixed).permit(:buy_date, :buy_quantity, :buy_price, :description, :short_name, :advisor, :end_date, :tax_index, :rate_index)
  end
end
