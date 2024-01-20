class RechargesController < ApplicationController
  def self.recharge(json)
    RechargeATMService.new(json: json).execute
    response(atm.reload)
  rescue ATMUnderUseError => e
    response(atm.reload, e.message)
  end
end
