RSpec.describe 'SessionController', :vcr do
include ControllerMixin

  let!(:user) { create :user }

  describe 'POST \sign_in' do
    context 'when user exists' do
      it 'shows main page' do
        post '/sign_in', email: 'example@example.com', password: '12345678'
        expect(response.status).to eq 302
        expect(response.location).to eq "http://example.org/"
      end
    end

    context 'when there are no users with such credentials' do
      it "don't show main page" do
        post '/sign_in', email: 'example1@example.com', password: '12345678'
        expect(response.status).to eq 302
        expect(response.location).to eq "http://example.org/sign_in"
      end
    end
  end

  describe 'GET \sign_out' do

    it 'redirects to sign in page' do
      post '/sign_in', email: 'example@example.com', password: '12345678'
      get '/sign_out'
      expect(response.location).to eq "http://example.org/sign_in"
    end
  end
end
