# frozen_string_literal: true

require 'spec_helper'

describe WithdrawalsController do
  before(:each) do
    Withdrawals.withdrawals = []
    ATMS.atm = nil
  end

  context 'complete successfull recharge' do
    let!(:atm) do
      ATM.create({
                   caixaDisponivel: true,
                   notas: { notasDez: 5, notasVinte: 5, notasCinquenta: 5, notasCem: 5 }
                 })
    end
    let(:json) { { saque: { valor: 100, horario: DateTime.now.to_s } } }
    let(:controller) { described_class.new(json) }

    it do
      expect { controller.withdrawal }.to output(
        '\n\nSaída:\n{\"caixa\":{\"caixaDisponivel\":true,\"notas\":{\"notasDez\":5,\"notasVinte\":5,\"notasCinquenta\":5,\"notasCem\":4}},\"erros\":[\"\"]}\n'.gsub('\\n', "\n").gsub(
          '\\', ''
        )
      ).to_stdout
    end
  end

  context 'complete unsuccessfull due to none atm registered' do
    let(:json) { { saque: { valor: 100, horario: DateTime.now.to_s } } }
    let(:controller) { described_class.new(json) }

    it do
      expect { controller.withdrawal }.to output(
        '\n\nSaída:\n{\"caixa\":{},\"erros\":[\"caixa-inexistente\"]}\n'.gsub('\\n', "\n").gsub('\\', '')
      ).to_stdout
    end
  end
end
