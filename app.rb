require_relative 'lib'

input = nil

while input != 'exit' do
  begin
    puts "\n\nEntrada:"
    input = gets.chomp

    json = JSON.parse(input, symbolize_names: true)

    if json.has_key?(:caixa)
      RechargesController.new(json).recharge
    elsif json.has_key?(:saque)
      WithdrawalsController.new(json).withdrawal
    end
  rescue => e
    puts e.message
    puts e.backtrace
  end
end
