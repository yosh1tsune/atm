class ATM
  attr_accessor :caixaDisponivel, :notas

  $atm = nil

  def self.create(json)
    $atm = { caixaDisponivel: json[:caixaDisponivel], notas: json[:notas] }
    ATM.new(**$atm)
  end

  def self.first
    return nil unless $atm

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

  def value_available
    (notas[:notasDez] * 10) + (notas[:notasVinte] * 20) + (notas[:notasCinquenta] * 50) + (notas[:notasCem] * 100)
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
