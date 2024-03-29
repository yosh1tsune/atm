# frozen_string_literal: true

class RechargeATMService
  attr_reader :json

  def initialize(json:)
    @json = json
  end

  def execute
    raise ATMUnderUseError.new('caixa-em-uso', atm: atm) if atm.caixaDisponivel

    atm.add_notes_and_update_status(json[:caixa])
  end

  private

  def atm
    @atm ||= ATM.first || ATM.create({
                                       caixaDisponivel: false,
                                       notas: { notasDez: 0, notasVinte: 0, notasCinquenta: 0, notasCem: 0 }
                                     })
  end
end
