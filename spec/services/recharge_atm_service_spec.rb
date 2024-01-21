# frozen_string_literal: true

require 'spec_helper'

describe RechargeATMService do
  let(:service) { described_class.new(json: json) }
  let(:json) do
    {
      "caixa": {
        "caixaDisponivel":true,
        "notas": {
          "notasDez":100,
          "notasVinte":50,
          "notasCinquenta":10,
          "notasCem":30
        }
      }
    }
  end

  context 'success' do
    it 'if atm is inexistent' do
      ATMS.atm = nil
      atm = service.execute

      expect(atm.class).to eq(ATM)
      expect(atm.caixaDisponivel).to eq(true)
      expect(atm.notas).to eq({ "notasDez":100,"notasVinte":50,"notasCinquenta":10,"notasCem":30 })
    end

    it 'if atm exists and caixaDisponivel is false' do
      ATM.create({
        caixaDisponivel: false,
        notas: { notasDez: 0, notasVinte: 0, notasCinquenta: 0, notasCem: 0 }
      })
      atm = service.execute

      expect(atm.class).to eq(ATM)
      expect(atm.caixaDisponivel).to eq(true)
      expect(atm.notas).to eq({ "notasDez":100,"notasVinte":50,"notasCinquenta":10,"notasCem":30 })
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

    it 'if caixaDisponivel is true' do
      expect{ service.execute }.to raise_error(ATMUnderUseError)

      expect(atm.reload.notas).to eq({ notasDez: 1, notasVinte: 2, notasCinquenta: 1, notasCem: 1})
    end
  end
end
