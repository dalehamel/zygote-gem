require File.expand_path('../../spec_helper.rb', __FILE__)

RSpec.describe ZygoteWeb do
  include SynchronySpec
  context 'routes' do
    it 'renders /' do
      zygote.start
      match_fixture('ipxe_boot', get('/').response)
    end

    it 'renders /chain' do
      zygote.start
      match_fixture('ipxe_menu', get('/chain', MOC_PARAMS['routing']['chain']).response)
    end

    it 'renders /cell/test/test' do
      zygote.start
      match_fixture('cell_test_action', get('/cell/test/test', MOC_PARAMS['routing']['cell_test']).response)
    end

  end
end
