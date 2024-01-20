# frozen_string_literal: true

require 'spec_helper'

describe SelectNotesService do
  let(:service) { SelectNotesService.new(withdrawal: withdrawal) }

  context 'success' do
    let(:withdrawal) { Withdrawal.new(valor: 230, horario: DateTime.now.to_s) }
    let!(:atm) do
      ATM.create({
        caixaDisponivel: true,
        notas: { notasDez: 100, notasVinte: 10, notasCinquenta: 5, notasCem: 1}
      })
    end

    it 'select notes correctly' do
      expect(service.execute).to eq({:notasCem=>0, :notasCinquenta=>3, :notasVinte=>9, :notasDez=>99})
    end
  end

  context 'fail' do
    let(:withdrawal) { Withdrawal.new(valor: 210, horario: DateTime.now.to_s) }
    let!(:atm) do
      ATM.create({
        caixaDisponivel: true,
        notas: { notasDez: 1, notasVinte: 2, notasCinquenta: 1, notasCem: 1}
      })
    end

    it 'value above available' do
      expect{ service.execute }.to raise_error(ValueUnavailableError)
    end

    it 'value not multiple of 10' do
      withdrawal = Withdrawal.new(valor: 12, horario: DateTime.now.to_s)

      expect{ service.execute }.to raise_error(ValueUnavailableError)
    end
  end
end
