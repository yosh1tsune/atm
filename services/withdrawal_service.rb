class WithdrawalService
  attr_reader :json, :atm

  def initialize(json:)
    @json = json
    @atm = ATM.first
  end

  def execute
    raise ATMUnavailableError unless atm.caixaDisponivel

    raise DuplicatedWithdrawalError if duplicated?

    withdrawal = Withdrawal.create(json[:saque])

    SelectNotesService.new(withdrawal: withdrawal).execute

    response(atm)
  rescue => e
    response(atm, e.message)
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
    pp(
      {
        'caixa': {
          'caixaDisponivel': atm.caixaDisponivel,
          'notas': atm.notas,
          'erros': [error]
        }
      }
    )
  end
end
