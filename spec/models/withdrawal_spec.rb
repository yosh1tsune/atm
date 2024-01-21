# frozen_string_literal: true

require 'spec_helper'

describe ATM do
  let(:datetime) { DateTime.now.to_s }

  context '.new' do
    let(:withdrawal) do
      Withdrawal.new(valor: 100, horario: datetime)
    end

    it 'instantiate record correctly' do
      expect(withdrawal.class).to eq Withdrawal
      expect(withdrawal.valor).to eq 100
      expect(withdrawal.horario).to eq DateTime.parse(datetime)
    end
  end

  context '.all' do
    let!(:withdrawals) do
      [
        Withdrawal.new(valor: 100, horario: datetime).save,
        Withdrawal.new(valor: 200, horario: datetime).save
      ]
    end

    it 'list all existing withdrawals' do
      expect(Withdrawal.all.count).to eq 2
      expect(Withdrawal.all.first.valor).to eq 100
      expect(Withdrawal.all.last.valor).to eq 200
    end
  end

  context '.save' do
    it 'store values into global variable' do
      Withdrawal.new(valor: 300, horario: datetime).save

      expect(Withdrawals.withdrawals).to include({ valor: 300, horario: DateTime.parse(datetime) })
    end
  end
end
