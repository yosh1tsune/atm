class WithdrawalService
  attr_reader :json, :atm

  def initialize(json:)
    @json = json
    @atm = ATM.first
  end

  def execute
    raise InexistentATMError unless ATM.first

    raise ATMUnavailableError unless atm.caixaDisponivel

    raise DuplicatedWithdrawalError if duplicated?

    withdrawal = Withdrawal.new(**json[:saque])

    SelectNotesService.new(withdrawal: withdrawal).execute

    withdrawal.save

    response(atm.reload)
  rescue InexistentATMError => e
    puts "\n\n"
    puts({ 'caixa': {}, 'erros': [e.message] }.to_json)
  rescue ATMUnavailableError, DuplicatedWithdrawalError, ValueUnavailableError => e
    response(atm.reload, e.message)
  end

  private

  def duplicated?
    Withdrawal.all.any? do |withdrawal|
      withdrawal.valor == json[:saque][:valor] && unauthorized_period?(withdrawal.horario, json[:saque][:horario])
    end
  end

  def unauthorized_period?(older_withdrawal_time, current_withdrawal_time)
    ((older_withdrawal_time - DateTime.parse(current_withdrawal_time)) * 24 * 60).to_i.abs < 10
  end

  def response(atm, error = '')
    puts "\n\n"
    puts(
      {
        'caixa': {
          'caixaDisponivel': atm.caixaDisponivel,
          'notas': atm.notas
        },
        'erros': [error]
      }.to_json
    )
  end
end
