module Withdrawals
  class << self
    attr_accessor :withdrawals
  end
end

class Withdrawal
  attr_accessor :valor, :horario

  Withdrawals.withdrawals = []

  def self.all
    Withdrawals.withdrawals.map do |withdrawal|
      Withdrawal.new(valor: withdrawal[:valor], horario: withdrawal[:horario].to_s)
    end
  end

  def initialize(valor:, horario:)
    @valor = valor.to_i
    @horario = DateTime.parse(horario)
  end

  def save
    Withdrawals.withdrawals << { valor: valor, horario: horario }
  end
end
