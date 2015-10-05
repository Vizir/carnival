require 'spec_helper'
require_relative '../../../../app/models/carnival/query_form'

RSpec.describe Carnival::QueryForm do
  let(:model) { described_class.new(params) }

  describe '#advanced_search' do
    context 'when there is an advanced_search' do
      let(:params) { { advanced_search: 'some-value' } }
      it { expect(model.advanced_search).to eq('some-value') }
    end

    context 'when an advanced_search is not given' do
      let(:params) { Hash.new }
      it { expect(model.advanced_search).to eq({}) }
    end
  end

  describe '#to_hash' do
    let(:params) do
      {
        scope: 'some-scope',
        search_term: 'some-term',
        advanced_search: 'some-search',
        date_period_label: 'some-date-label',
        date_period_from: 'some-date-from',
        date_period_to: 'some-date-to',
        sort_column: 'some-sort-column',
        sort_direction: 'some-sort-direction',
        page: '5'
      }
    end

    it 'returns a hash with all params' do
      expect(model.to_hash).to eq({
        'scope' => 'some-scope',
        'search_term' => 'some-term',
        'advanced_search' => 'some-search',
        'date_period_label' => 'some-date-label',
        'date_period_from' => 'some-date-from',
        'date_period_to' => 'some-date-to',
        'sort_column' => 'some-sort-column',
        'sort_direction' => 'some-sort-direction',
        'page' => 5
      })
    end
  end

  describe '#page' do
    context 'when there is a page' do
      let(:params) { { page: '5' } }
      it { expect(model.page).to eq(5) }
    end

    context 'when a page is not given' do
      let(:params) { Hash.new }
      it { expect(model.page).to eq(1) }
    end
  end
end
