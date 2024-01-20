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

  def update(json)
    $atm = { caixaDisponivel: json[:caixaDisponivel], notas: json[:notas] }
    reload
  end

  def reload
    ATM.first
  end

  def value_available
    (notas[:notasDez] * 10) + (notas[:notasVinte] * 20) + (notas[:notasCinquenta] * 50) + (notas[:notasCem] * 100)
  end
end
