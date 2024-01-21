# frozen_string_literal: true

require_relative 'lib'

input = nil
json = ''
while json != 'exit'
  puts "\n\nEntrada:"

  json = ''
  loop do
    input = $stdin.sysread(1)
    json += input if input != "\n"
  rescue EOFError
    break
  end

  break if json == 'exit'

  json = JSON.parse(json, symbolize_names: true)

  if json.key?(:caixa)
    RechargesController.new(json).recharge
  elsif json.key?(:saque)
    WithdrawalsController.new(json).withdrawal
  end
end

# while input != 'exit'
#   begin
#     puts "\n\nEntrada:"
#     input = gets.chomp

#     json = JSON.parse(input, symbolize_names: true)

#     if json.key?(:caixa)
#       RechargesController.new(json).recharge
#     elsif json.key?(:saque)
#       WithdrawalsController.new(json).withdrawal
#     end
#   rescue StandardError => e
#     puts e.message
#     puts e.backtrace
#   end
# end
