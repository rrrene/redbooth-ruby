require "spec_helper"

describe Redbooth::Client do
  let(:consumer_key) { '_your_consumen_key_' }
  let(:consumer_secret) { '_your_consumen_secret_' }
  let(:access_token) do
    {
      token: '_your_user_token_',
      secret: '_your_secret_token_'
    }
  end
  let(:client) { Redbooth::Client.new(session) }
  let(:session) { Redbooth::Session.new(access_token) }
  let(:valid_attributes) { JSON.parse('{}') }

  before :each do
    allow(Redbooth).to receive(:request).and_return(valid_attributes)
  end

  describe '#initialize' do
    it 'initializes attributes correctly' do
      expect(client.session).to eql(session)
    end
    it 'raises Redbooth::AuthenticationError if session is invalid' do
      allow(session).to receive(:valid?).and_return(false)

      expect{client}.to raise_error{ Redbooth::AuthenticationError }
    end
  end

  describe '#perform!' do
    it 'is private' do
      expect{client.perform!(:user, :show)}.to raise_error
    end
    it 'raises Redbooth::AuthenticationError if session is invalid' do
      allow(client).to receive(:session).and_return(nil)
      expect{client.perform!(:user, :show)}.to raise_error{ Redbooth::AuthenticationError }
    end
    it 'calls to the given resource' do
      allow(Redbooth::User).to receive(:show).and_return(Redbooth::User.new)
      expect(Redbooth::User).to receive(:show).with({ session: session })

      client.send(:perform!, :user, :show)
    end
  end

  describe '#options_with_session' do
    it 'is private' do
      expect{client.options_with_session({})}.to raise_error
    end
    it 'adds the session to the given options' do
      expect(client.send(:options_with_session,{})).to include(:session)
      expect(client.send(:options_with_session,{})[:session]).to eql(session)
    end
  end

  describe '#resource' do
    it 'is private' do
      expect{client.resource('user')}.to raise_error
    end
    it 'gives the correct api resource class' do
      expect(client.send(:resource, 'user')).to eql(Redbooth::User)
    end
    it 'gives nil if there is no resource for the given name' do
      expect(client.send(:resource, 'icecream')).to be_nil
    end
  end

end
