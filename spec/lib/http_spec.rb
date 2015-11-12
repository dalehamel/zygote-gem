require File.expand_path('../../spec_helper.rb', __FILE__)

RSpec.describe ZygoteWeb do
  include SynchronySpec
  context 'routes' do
    it 'renders /' do
      zygote.start
      expect(get('/').response).to eq(fixture('ipxe_boot'))
    end
  end
end
