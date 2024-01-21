class RechargesController < ApplicationController
  def recharge
    atm = RechargeATMService.new(json: json).execute
    response(atm.reload)
  rescue ATMUnderUseError => e
    response(e.atm.reload, e.message)
  end
end
