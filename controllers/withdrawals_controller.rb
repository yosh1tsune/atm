class WithdrawalsController
  def self.withdrawal(json)
    WithdrawalService.new(json: json).execute
  end
end
