class Withdrawal
  attr_accessor :valor, :horario

  $withdrawals = []

  def self.all
    $withdrawals.map do |withdrawal|
      Withdrawal.new(valor: withdrawal[:valor], horario: withdrawal[:horario])
    end
  end

  def initialize(valor:, horario:)
    @valor = valor.to_i
    @horario = DateTime.parse(horario)
  end

  def save
    $withdrawals << { valor: valor, horario: horario }
  end
end
