# frozen_string_literal: true

require 'spec_helper'

describe RechargesController do
  context 'execute' do
    it 'complete successfull recharge' do
      json = { caixa: { caixaDisponivel: false,
                        notas: { notasDez: 100, notasVinte: 50, notasCinquenta: 10, notasCem: 30 } } }
      controller = described_class.new(json)

      expect { controller.recharge }.to output(
        "\n\nSaída:\n{\"caixa\":{\"caixaDisponivel\":false,\"notas\":{\"notasDez\":100,\"notasVinte\":50,"\
        '\"notasCinquenta\":10,\"notasCem\":30}},\"erros\":[\"\"]}\n'.gsub('\\n', "\n").gsub(
          '\\', ''
        )
      ).to_stdout
    end

    it 'complete unsuccessfull recharge due to atm under use' do
      ATM.create({
                   caixaDisponivel: true,
                   notas: { notasDez: 5, notasVinte: 5, notasCinquenta: 5, notasCem: 5 }
                 })
      json = { caixa: { caixaDisponivel: false,
                        notas: { notasDez: 100, notasVinte: 50, notasCinquenta: 10, notasCem: 30 } } }
      controller = described_class.new(json)

      expect { controller.recharge }.to output(
        "\n\nSaída:\n{\"caixa\":{\"caixaDisponivel\":true,\"notas\":{\"notasDez\":5,\"notasVinte\":5,"\
        '\"notasCinquenta\":5,\"notasCem\":5}},\"erros\":[\"caixa-em-uso\"]}\n'.gsub('\\n', "\n").gsub(
          '\\', ''
        )
      ).to_stdout
    end
  end
end
