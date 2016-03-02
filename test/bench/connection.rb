require_relative './bench_init'

context 'Connection' do
  test 'Establishing Connection Internally' do
    response = HTTP::Commands::Get.("http://www.example.com")

    assert response.status_code == 200
  end
end
