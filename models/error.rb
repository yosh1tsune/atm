# frozen_string_literal: true

class Error < StandardError
end

class ATMUnderUseError < Error
  attr_reader :atm

  def initialize(msg = 'caixa-em-uso', atm = nil)
    @atm = atm[:atm]
    super(msg)
  end
end

class InexistentATMError < Error
  def initialize(msg = 'caixa-inexistente')
    super
  end
end

class ATMUnavailableError < Error
  def initialize(msg = 'caixa-indisponivel')
    super
  end
end

class DuplicatedWithdrawalError < Error
  def initialize(msg = 'saque-duplicado')
    super
  end
end

class ValueUnavailableError < Error
  def initialize(msg = 'valor-indisponivel')
    super
  end
end
