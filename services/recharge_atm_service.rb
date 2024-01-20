class RechargeATMService
  attr_reader :json

  def initialize(json:)
    @json = json
  end

  def execute
    raise ATMUnderUseError if atm.caixaDisponivel

    atm.save(json)
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
end
