require 'spec_helper'

describe 'carnival/base_admin/show.html.haml' do
  context 'when a presenter has a custom partial view in a given field' do
    it 'should render the specified partial view' do
      assign(:country, create(:country, name: 'Brazil'))
      assign(:model_presenter, Admin::CountryPresenter.new(controller: controller))

      view.stub(caminho_modelo: '/admin/countries')

      view.stub(:render).and_call_original
      view.stub(:render).with(hash_including(:partial => 'name')).and_return('Stubbed country')

      render

      rendered.should =~ /Stubbed country/
    end
  end
end
