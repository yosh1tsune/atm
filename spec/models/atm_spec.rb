# frozen_string_literal: true

require 'spec_helper'

describe ATM do
  context 'initialize' do
    let(:atm) do
      ATM.new(caixaDisponivel: false, notas: { notasDez: 0, notasVinte: 0, notasCinquenta: 0, notasCem: 0 })
    end

    it 'instantiate record correctly' do
      expect(atm.class).to eq ATM
      expect(atm.caixaDisponivel).to eq false
      expect(atm.notas).to eq({ notasCem: 0, notasCinquenta: 0, notasDez: 0, notasVinte: 0 })
    end
  end

  context 'create' do
    let!(:atm) do
      ATM.create({
        caixaDisponivel: false,
        notas: { notasDez: 0, notasVinte: 0, notasCinquenta: 0, notasCem: 0 }
      })
    end

    it 'instantiate record and save on global variable' do
      expect(ATMS.atm).to eq({ caixaDisponivel: false, notas: { notasCem: 0, notasCinquenta: 0, notasDez: 0, notasVinte:0 } })
      expect(atm.class).to eq ATM
      expect(atm.caixaDisponivel).to eq false
      expect(atm.notas).to eq({ notasCem: 0, notasCinquenta: 0, notasDez: 0, notasVinte: 0 })
    end
  end

  context 'first' do
    before { ATMS.atm = nil }
    it 'return nil if no atm where created' do
      expect(ATM.first).to eq nil
    end

    it 'return atm' do
      ATM.create({
        caixaDisponivel: false,
        notas: { notasDez: 5, notasVinte: 5, notasCinquenta: 5, notasCem: 5 }
      })

      expect(ATM.first.class).to eq ATM
      expect(ATM.first.caixaDisponivel).to eq false
      expect(ATM.first.notas).to eq({ notasCem: 5, notasCinquenta: 5, notasDez: 5, notasVinte: 5 })
    end
  end

  context '.add_notes_and_update_status' do
    it 'update global variable' do
      atm_update_values = { caixaDisponivel: true, notas: { notasDez: 10, notasVinte: 10, notasCinquenta: 10, notasCem: 10 }}
      atm = ATM.create(caixaDisponivel: false, notas: { notasDez: 5, notasVinte: 5, notasCinquenta: 5, notasCem: 5 }).add_notes_and_update_status(atm_update_values)

      expect(ATMS.atm).to eq({ caixaDisponivel: true, notas: { notasDez: 15, notasVinte: 15, notasCinquenta: 15, notasCem: 15 }})
      expect(atm.class).to eq ATM
      expect(atm.caixaDisponivel).to eq true
      expect(atm.notas).to eq({ notasDez: 15, notasVinte: 15, notasCinquenta: 15, notasCem: 15 })
    end
  end

  context 'value available' do
    let(:atm) do
      atm = ATM.create({
        caixaDisponivel: false,
        notas: { notasDez: 1, notasVinte: 1, notasCinquenta: 1, notasCem: 1 }
      })
    end

    it 'sum and multiple notes acordingly their value to show total amount available' do
      expect(atm.value_available).to eq 180
    end
  end
end
