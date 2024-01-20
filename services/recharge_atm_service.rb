class RechargeATMService
  attr_reader :json

  def initialize(json:)
    @json = json
  end

  def execute
    raise ATMUnderUseError if atm.caixaDisponivel

    atm.save(json)

    response(atm.reload)
  rescue ATMUnderUseError => e
    response(atm.reload, e.message)
  end

  private

  def atm
    @atm ||= if ATM.first
               ATM.first
             else
               ATM.create({
                 caixaDisponivel: false,
                 notas: { notasDez: 0, notasVinte: 0, notasCinquenta: 0, notasCem: 0 }
               })
             end
  end

  def response(atm, error = '')
    puts "\n\n"
    puts(
      {
        'caixa': {
          'caixaDisponivel': atm.caixaDisponivel,
          'notas': atm.notas,
          'erros': [error]
        }
      }.to_json
    )
  end
end
