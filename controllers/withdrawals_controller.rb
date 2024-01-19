class WithdrawalsController
  def self.withdraw(json)
    WithdrawalService.new(json: json).execute
  end
end
