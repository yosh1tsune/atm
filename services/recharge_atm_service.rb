class RechargeATMService
  attr_reader :json

  def initialize(json:)
    @json = json
  end

  def execute
    atm = ATM.first

    raise StandardError if atm.caixaDisponivel

    atm = atm.save(json)

    response(atm)
  rescue => e
    response(atm, 'caixa-em-uso')
  end

  private

  def add_bank_notes

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