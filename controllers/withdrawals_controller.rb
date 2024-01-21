# frozen_string_literal: true

class WithdrawalsController < ApplicationController
  def withdrawal
    atm = ATM.first
    WithdrawalService.new(atm: atm, json: json).execute
    response(atm.reload)
  rescue InexistentATMError => e
    puts "\n\nSaída:"
    puts({ 'caixa': {}, 'erros': [e.message] }.to_json)
  rescue ATMUnavailableError, DuplicatedWithdrawalError, ValueUnavailableError => e
    response(atm.reload, e.message)
  end
end
