# frozen_string_literal: true

require_relative 'lib'

input = nil

while input != 'exit'
  begin
    puts "\n\nEntrada:"
    input = gets.chomp

    json = JSON.parse(input, symbolize_names: true)

    if json.key?(:caixa)
      RechargesController.new(json).recharge
    elsif json.key?(:saque)
      WithdrawalsController.new(json).withdrawal
    end
  rescue StandardError => e
    puts e.message
    puts e.backtrace
  end
end
