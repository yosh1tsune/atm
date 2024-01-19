require 'lib'

input = nil

while input != 'exit' do
  begin
    input = $stdin.gets.chomp

    json = JSON.parse(input, symbolize_names: true)

    if json.has_key?(:caixa)
      RechargesController.recharge(json)
    elsif json.has_key?(:saque)
      WithdrawalsController.withdraw(json)
    end
  rescue => e
  end
end

{ "caixa":{ "caixaDisponivel":true, "notas":{ "notasDez":100, "notasVinte":50, "notasCinquenta":10, "notasCem":30 } } }

{"saque":{"valor":80,"horario":"2019-02-13T11:01:01.000Z"}}

{"saque":{"valor":80,"horario":"2019-02-13T11:25:01.000Z"}}