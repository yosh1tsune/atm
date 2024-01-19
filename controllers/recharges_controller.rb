class RechargesController
  def self.recharge(json)
    RechargeATMService.new(json: json).execute
  end
end
