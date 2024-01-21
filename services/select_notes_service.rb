# frozen_string_literal: true

class SelectNotesService
  attr_accessor :withdrawal, :atm

  POSSIBLE_NOTES = [
    { name: :notasCem, value: 100 },
    { name: :notasCinquenta, value: 50 },
    { name: :notasVinte, value: 20 },
    { name: :notasDez, value: 10 }
  ]

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
    while value != 0
      POSSIBLE_NOTES.map do |note|
        if value >= note[:value] && atm.notas[note[:name]].positive?
          value = select_notes(value, note[:value], note[:name])
        end
      end
    end
    atm.notas
  end

  def select_notes(withdrawal_value, note_value, note_name)
    quantity_needed = (withdrawal_value / note_value)
    if atm.notas[note_name] < quantity_needed
      withdrawal_value -= value_in_notes(atm.notas[note_name], note_value)
      atm.notas[note_name] = 0
    else
      withdrawal_value -= value_in_notes(quantity_needed, note_value)
      atm.notas[note_name] -= quantity_needed
    end
    withdrawal_value
  end

  def value_in_notes(quantity, nominal_value)
    quantity * nominal_value
  end
end
