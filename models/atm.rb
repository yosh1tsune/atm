class ATM
  attr_accessor :caixaDisponivel, :notas

  $atm = { caixaDisponivel: false, notas: { notasDez: 0, notasVinte: 0, notasCinquenta: 0, notasCem: 0 } }

  def self.first
    ATM.new(**$atm)
  end

  def initialize(caixaDisponivel:, notas:)
    @caixaDisponivel = caixaDisponivel
    @notas = notas
  end

  def save(json)
    $atm = { caixaDisponivel: json[:caixa][:caixaDisponivel], notas: update_notes(json[:caixa][:notas]) }
    reload
  end

  def reload
    ATM.first
  end

  private

  def update_notes(json)
    {
      notasDez: notas[:notasDez] + json[:notasDez],
      notasVinte: notas[:notasVinte] + json[:notasVinte],
      notasCinquenta: notas[:notasCinquenta] + json[:notasCinquenta],
      notasCem: notas[:notasCem] + json[:notasCem]
    }
  end
end
