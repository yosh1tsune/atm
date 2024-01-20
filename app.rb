require_relative 'lib'

input = nil

while input != 'exit' do
  begin
    input = gets.chomp

    json = JSON.parse(input, symbolize_names: true)

    if json.has_key?(:caixa)
      RechargesController.recharge(json)
    elsif json.has_key?(:saque)
      WithdrawalsController.withdrawal(json)
    end
  rescue => e
    puts e.message
    puts e.backtrace
  end
end
