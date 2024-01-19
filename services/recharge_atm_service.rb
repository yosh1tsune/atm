class RechargeATMService
  attr_reader :json

  def initialize(json:)
    @json = json
  end

  def execute
    atm = ATM.first

    raise ATMUnderUseError if atm.caixaDisponivel

    atm = atm.save(json)

    response(atm)
  rescue => e
    response(atm, e.message)
  end

  private

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
