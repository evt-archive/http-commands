require_relative './spec_init'

context 'Connection' do
  test 'Establishing Connection Internally' do
    response = HTTP::Commands::Get.("https://www.google.com")

    assert response.status_code == 200
  end
end
