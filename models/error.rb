class Error < StandardError
end

class ATMUnderUseError < Error
  def initialize(msg='caixa-em-uso')
    super
  end
end

class InexistentATMError < Error
  def initialize(msg='caixa-inexistente')
    super
  end
end

class ATMUnavailableError < Error
  def initialize(msg='caixa-indisponivel')
    super
  end
end

class DuplicatedWithdrawalError < Error
  def initialize(msg='saque-duplicado')
    super
  end
end

class ValueUnavailableError < Error
  def initialize(msg='valor-indisponivel')
    super
  end
end
