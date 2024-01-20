class ApplicationController
  def self.response(atm, error = '')
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
