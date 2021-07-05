class StockPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def show?
    record.portfolio.user == user
  end
  
  def create?
    return true
  end

  def update?
    record.portfolio.user == user
  end

  def destroy?
    record.portfolio.user == user
  end

  # def choose_stock?
  #   return true
  # end

  # def update_stocks_price?
  #   record.user == user
  # end

  # def choose_fund?
  #   return true
  # end

  # def update_funds_price?
  #   record.user == user
  # end
end

