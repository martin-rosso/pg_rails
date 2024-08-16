require 'rails_helper'

describe PgEngine::DateJumper do
  subject do
    jumper.send(method, days, exclude_holidays:)
  end

  let(:method) { self.class.metadata[:method] }
  let(:jumper) { described_class.new(start_date) }
  let(:start_date) { Date.new(2024, 8, 16) }
  let(:days) { 5 }
  let(:exclude_holidays) { false }

  def fake_holiday(date)
    allow(Holidays).to receive(:on).and_call_original
    allow(Holidays).to receive(:on).with(date, anything)
                                   .and_return([:some_fake_holiday])
  end

  describe 'business_forward', method: 'business_forward' do
    it do
      expect(subject).to eq Date.new(2024, 8, 23)
    end

    context 'excluding holidays' do
      before do
        fake_holiday(Date.new(2024, 8, 23))
      end

      let(:exclude_holidays) { true }

      it do
        expect(subject).to eq Date.new(2024, 8, 26)
      end
    end
  end

  describe 'business_forward', method: 'business_backward' do
    it do
      expect(subject).to eq Date.new(2024, 8, 9)
    end

    context 'excluding holidays' do
      before do
        fake_holiday(Date.new(2024, 8, 14))
      end

      let(:exclude_holidays) { true }

      it do
        expect(subject).to eq Date.new(2024, 8, 8)
      end
    end
  end
end
