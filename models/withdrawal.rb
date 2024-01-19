class Withdrawal
  attr_accessor :valor, :horario

  $withdrawals = []

  def self.all
    $withdrawals.map { |withdraw| Withdrawal.new(valor: withdraw[:valor].to_i, horario: DateTime.parse(withdraw[:horario])) }
  end

  def self.create(json)
    $withdrawals << json
  end

  def initialize(valor:, horario:)
    @valor = valor
    @horario = horario
  end
end
