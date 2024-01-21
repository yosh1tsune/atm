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
