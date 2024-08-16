require 'rails_helper'

RSpec.describe 'Users::DateJumpers' do
  describe 'GET /jump' do
    before do
      stubs if defined? stubs
      get '/u/date_jumper/jump', params: {
        start_date:,
        quantity:,
        type:,
        direction:
      }
    end

    let(:start_date) { Date.new(2024, 8, 16) }
    let(:quantity) { 5 }

    context 'when moving calendar days' do
      let(:type) { 'calendar_days' }

      context 'forward' do
        let(:direction) { 'forward' }

        it do
          expect(JSON.parse(response.body)['date']).to eq '2024-08-21'
        end
      end

      context 'backward' do
        let(:direction) { 'backward' }

        it do
          expect(JSON.parse(response.body)['date']).to eq '2024-08-11'
        end
      end
    end

    context 'when moving business days' do
      let(:type) { 'business_days' }

      context 'forward' do
        let(:direction) { 'forward' }

        it do
          expect(JSON.parse(response.body)['date']).to eq '2024-08-23'
        end
      end

      context 'backward' do
        let(:direction) { 'backward' }

        it do
          expect(JSON.parse(response.body)['date']).to eq '2024-08-09'
        end
      end
    end

    context 'when moving business days excluding holidays' do
      def fake_holiday(date)
        allow(Holidays).to receive(:on).and_call_original
        allow(Holidays).to receive(:on).with(date, anything)
                                       .and_return([:some_fake_holiday])
      end

      let(:type) { 'business_days_excluding_holidays' }

      context 'forward' do
        let(:stubs) do
          fake_holiday(Date.new(2024, 8, 23))
        end

        let(:direction) { 'forward' }

        it do
          expect(JSON.parse(response.body)['date']).to eq '2024-08-26'
        end
      end

      context 'backward' do
        let(:stubs) do
          fake_holiday(Date.new(2024, 8, 14))
        end

        let(:direction) { 'backward' }

        it do
          expect(JSON.parse(response.body)['date']).to eq '2024-08-08'
        end
      end
    end

    context 'when moving weeks' do
      let(:type) { 'week' }

      context 'forward' do
        let(:direction) { 'forward' }

        it do
          expect(JSON.parse(response.body)['date']).to eq '2024-09-20'
        end
      end

      context 'backward' do
        let(:direction) { 'backward' }

        it do
          expect(JSON.parse(response.body)['date']).to eq '2024-07-12'
        end
      end
    end

    context 'when moving months' do
      let(:type) { 'month' }

      context 'forward' do
        let(:direction) { 'forward' }

        it do
          expect(JSON.parse(response.body)['date']).to eq '2025-01-16'
        end
      end

      context 'backward' do
        let(:direction) { 'backward' }

        it do
          expect(JSON.parse(response.body)['date']).to eq '2024-03-16'
        end
      end
    end
  end
end
