class WithdrawalService
  attr_reader :json, :atm

  def initialize(json:)
    @json = json
    @atm = ATM.first
  end

  def execute
    raise ATMUnavailableError unless atm.caixaDisponivel

    raise DuplicatedWithdrawError if duplicated?

    Withdrawal.create(json[:saque])

    response(atm)
  rescue => e
    response(atm, e.message)
  end

  private

  def duplicated?
    Withdrawal.all.any? do |withdraw|
      withdraw.valor == json[:saque][:valor] && unauthorized_period?(withdraw.horario, json[:saque][:horario])
    end
  end

  def unauthorized_period?(older_withdraw_time, current_withdraw_time)
    ((older_withdraw_time - DateTime.parse(current_withdraw_time)) * 24 * 60).to_i.abs < 10
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
