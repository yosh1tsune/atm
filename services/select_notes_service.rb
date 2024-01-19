class SelectNotesService
  attr_accessor :withdrawal, :atm

  def initialize(withdrawal:)
    @withdrawal = withdrawal
    @atm = ATM.first
  end

  def execute
    raise ValueUnavailableError if value_unavailable

    select_notes
  end

  private

  def value_unavailable
    (withdrawal.valor > atm.value_available) || withdrawal.valor % 10 != 0
  end

  def select_notes
    value = withdrawal.valor
    while value != 0 do
      if value >= 100 && atm.notas[:notasCem] > 0
        quantity_needed = (value / 100)
        if atm.notas[:notasCem] < quantity_needed
          value = value - (atm.notas[:notasCem] * 100)
          atm.notas[:notasCem] = 0
        else
          value = value - (quantity_needed * 100)
          atm.notas[:notasCem] = atm.notas[:notasCem] - quantity_needed
        end
      elsif value >= 50 && atm.notas[:notasCinquenta] > 0
        quantity_needed = (value / 50)
        if atm.notas[:notasCinquenta] < quantity_needed
          value = value - (atm.notas[:notasCinquenta] * 50)
          atm.notas[:notasCinquenta] = 0
        else
          value = value - (quantity_needed * 50)
          atm.notas[:notasCinquenta] = atm.notas[:notasCinquenta] - quantity_needed
        end
      elsif value >= 20 && atm.notas[:notasVinte] > 0
        quantity_needed = (value / 20)
        if atm.notas[:notasVinte] < quantity_needed
          value = value - (atm.notas[:notasVinte] * 20)
          atm.notas[:notasVinte] = 0
        else
          value = value - (quantity_needed * 20)
          atm.notas[:notasVinte] = atm.notas[:notasVinte] - quantity_needed
        end
      elsif value >= 10 && atm.notas[:notasDez] > 0
        quantity_needed = (value / 10)
        if atm.notas[:notasDez] < quantity_needed
          value = value - (atm.notas[:notasDez] * 10)
          atm.notas[:notasDez] = 0
        else
          value = value - (quantity_needed * 10)
          atm.notas[:notasDez] = atm.notas[:notasDez] - quantity_needed
        end
      end
    end
    atm.notas
  end
end


# Valor Disponivel
{"caixa":{"caixaDisponivel":true,"notas":{"notasDez":100,"notasVinte":50,"notasCinquenta":10,"notasCem":30}}}

{"saque":{"valor":960,"horario":"2019-02-13T11:11:01.000Z"}}

# Valor Indisponivel
{"caixa":{"caixaDisponivel":true,"notas":{"notasDez":0,"notasVinte":0,"notasCinquenta":1,"notasCem":3}}}

{"saque":{"valor":600,"horario":"2019-02-13T11:01:01.000Z"}}
