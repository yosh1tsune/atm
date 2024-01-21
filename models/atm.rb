module ATMS
  class << self
    attr_accessor :atm
  end
end


class ATM
  attr_accessor :caixaDisponivel, :notas

  ATMS.atm = nil

  def self.create(json)
    ATMS.atm = { caixaDisponivel: json[:caixaDisponivel], notas: json[:notas] }
    ATM.new(**ATMS.atm)
  end

  def self.first
    return nil unless ATMS.atm

    ATM.new(**ATMS.atm)
  end

  def initialize(caixaDisponivel:, notas:)
    @caixaDisponivel = caixaDisponivel
    @notas = notas
  end

  def add_notes_and_update_status(json)
    ATMS.atm = { caixaDisponivel: json[:caixaDisponivel], notas: sum_new_notes(json[:notas]) }
    reload
  end

  def reload
    ATM.first
  end

  def value_available
    (notas[:notasDez] * 10) + (notas[:notasVinte] * 20) + (notas[:notasCinquenta] * 50) + (notas[:notasCem] * 100)
  end

  private

  def sum_new_notes(json)
    {
      notasDez: notas[:notasDez] + json[:notasDez],
      notasVinte: notas[:notasVinte] + json[:notasVinte],
      notasCinquenta: notas[:notasCinquenta] + json[:notasCinquenta],
      notasCem: notas[:notasCem] + json[:notasCem]
    }
  end
end
