class SelectNotesService
  attr_accessor :withdrawal, :atm

  def initialize(withdrawal:)
    @withdrawal = withdrawal
    @atm = ATM.first
  end

  def execute
    raise ValueUnavailableError if value_unavailable

    process_withdrawal
  end

  private

  def value_unavailable
    (withdrawal.valor > atm.value_available) || withdrawal.valor % 10 != 0
  end

  def process_withdrawal
    value = withdrawal.valor
    while value != 0 do
      if value >= 100 && atm.notas[:notasCem] > 0
        value = select_notes(value, 100, :notasCem)
      elsif value >= 50 && atm.notas[:notasCinquenta] > 0
        value = select_notes(value, 50, :notasCinquenta)
      elsif value >= 20 && atm.notas[:notasVinte] > 0
        value = select_notes(value, 20, :notasVinte)
      elsif value >= 10 && atm.notas[:notasDez] > 0
        value = select_notes(value, 10, :notasDez)
      end
    end
    atm.notas
  end

  def select_notes(withdrawal_value, note_value, value_name)
    quantity_needed = (withdrawal_value / note_value)
    if atm.notas[value_name] < quantity_needed
      withdrawal_value = withdrawal_value - (atm.notas[value_name] * note_value)
      atm.notas[value_name] = 0
    else
      withdrawal_value = withdrawal_value - (quantity_needed * note_value)
      atm.notas[value_name] = atm.notas[value_name] - quantity_needed
    end
    withdrawal_value
  end
end


# Valor Disponivel
{"caixa":{"caixaDisponivel":true,"notas":{"notasDez":100,"notasVinte":50,"notasCinquenta":10,"notasCem":30}}}

{"saque":{"valor":960,"horario":"2019-02-13T11:11:01.000Z"}}

# Valor Indisponivel
{"caixa":{"caixaDisponivel":true,"notas":{"notasDez":0,"notasVinte":0,"notasCinquenta":1,"notasCem":3}}}

{"saque":{"valor":600,"horario":"2019-02-13T11:01:01.000Z"}}
