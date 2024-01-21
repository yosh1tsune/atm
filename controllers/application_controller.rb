class ApplicationController
  attr_reader :json
  def initialize(json)
    @json = json
  end

  def response(atm, error = '')
    puts "\n\nSaída:"
    puts(
      {
        'caixa': {
          'caixaDisponivel': atm.caixaDisponivel,
          'notas': atm.notas
        },
        'erros': [error]
      }.to_json
    )
  end
end
