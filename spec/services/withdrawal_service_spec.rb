# frozen_string_literal: true

require 'spec_helper'

describe WithdrawalService do
  let!(:atm) do
    ATM.create({
                 caixaDisponivel: true,
                 notas: { notasDez: 100, notasVinte: 10, notasCinquenta: 5, notasCem: 1 }
               })
  end
  let(:service) { WithdrawalService.new(atm: atm, json: json) }
  let(:json) { { saque: { valor: 180, horario: DateTime.now.to_s } } }

  context 'success' do
    it 'and select notes correctly' do
      expect do
        service.execute

        expect(atm.notas).to(eq { { notasDez: 99, notasVinte: 9, notasCinquenta: 4, notasCem: 0 } })
      end
    end
  end

  context 'fail' do
    context 'when atm is inexistent' do
      let!(:atm) { nil }

      it { expect { service.execute }.to raise_error(InexistentATMError) }
    end

    context 'when atm is unavailable' do
      let(:atm) do
        ATM.create({
                     caixaDisponivel: false,
                     notas: { notasDez: 1, notasVinte: 2, notasCinquenta: 1, notasCem: 1 }
                   })
      end

      it { expect { service.execute }.to raise_error(ATMUnavailableError) }
    end

    it 'with duplicated withdrawals' do
      Withdrawal.new(**json[:saque]).save

      expect { service.execute }.to raise_error(DuplicatedWithdrawalError)
    end

    context 'value unavailable' do
      let(:atm) do
        ATM.create({
                     caixaDisponivel: true,
                     notas: { notasDez: 1, notasVinte: 2, notasCinquenta: 1, notasCem: 1 }
                   })
      end
      let!(:service) { WithdrawalService.new(atm: atm, json: json) }

      context 'when notes are unavailable' do
        let(:json) { { saque: { valor: 1_800, horario: DateTime.now.to_s } } }

        it { expect { service.execute }.to raise_error(ValueUnavailableError) }
      end

      context 'when value is invalid' do
        let(:json) { { saque: { valor: 181, horario: DateTime.now.to_s } } }

        it { expect { service.execute }.to raise_error(ValueUnavailableError) }
      end
    end
  end
end
