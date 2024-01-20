class WithdrawalService
  attr_reader :json, :atm

  def initialize(atm:, json:)
    @json = json[:saque]
    @atm = atm
  end

  def execute
    raise InexistentATMError unless atm

    raise ATMUnavailableError unless atm.caixaDisponivel

    raise DuplicatedWithdrawalError if duplicated?

    withdrawal = Withdrawal.new(**json)

    SelectNotesService.new(withdrawal: withdrawal).execute

    withdrawal.save

    atm.reload
  end

  private

  def duplicated?
    Withdrawal.all.any? do |withdrawal|
      withdrawal.valor == json[:valor] && unauthorized_period?(withdrawal.horario, json[:horario])
    end
  end

  def unauthorized_period?(older_withdrawal_time, current_withdrawal_time)
    ((older_withdrawal_time - DateTime.parse(current_withdrawal_time)) * 24 * 60).to_i.abs < 10
  end
end
