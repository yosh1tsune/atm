require_relative 'models/recharge'
require_relative 'models/withdrawal'
require_relative 'models/atm'

require_relative 'controllers/recharges_controller'

require_relative 'services/recharge_atm_service'
require 'json'

input = nil

while input != 'exit' do
  begin
    input = $stdin.gets.chomp

    json = JSON.parse(input, symbolize_names: true)

    if json.has_key?(:caixa)
      RechargesController.recharge(json)
    elsif json.has_key?(:saque)
      WithdrawalsController.withdraw
    end
  rescue => e
    puts 'Operação inválida.'
  end
end

{ "caixa":{ "caixaDisponivel":true, "notas":{ "notasDez":100, "notasVinte":50, "notasCinquenta":10, "notasCem":30 } } }

{"saque":{"valor":80,"horario":"2019-02-13T11:01:01.000Z"}}