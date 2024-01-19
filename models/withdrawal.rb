class Withdrawal
  attr_reader :json

  def initialize(json:)
    @json = json
  end

  def execute
    puts 'Withdrawl', json
  end
end
