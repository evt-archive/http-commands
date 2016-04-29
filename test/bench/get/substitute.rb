require_relative '../bench_init'

context "Get Substitute" do
  context "Response" do
    context "Assignable" do
      substitute_get = HTTP::Commands::Get::Substitute.build

      substitute_get.status_code = 'some-status-code'
      substitute_get.reason_phrase = 'some-reason-phrase'
      substitute_get.response_body = 'some-response-body'

      response = substitute_get.()

      test "Status Code" do
        assert response.status_code == 'some-status-code'
      end

      test "Reason Phrase" do
        assert response.reason_phrase == 'some-reason-phrase'
      end

      test "Body" do
        assert response.body == 'some-response-body'
      end
    end

    context "Defaults" do
      substitute_get = HTTP::Commands::Get::Substitute.build
      response = substitute_get.()

      context "Status Code" do
        control_status_code = 200

        test control_status_code.to_s do
          assert response.status_code == control_status_code
        end
      end

      context "Reason Phrase" do
        control_reason_phrase = 'OK'

        test control_reason_phrase do
          assert response.reason_phrase == control_reason_phrase
        end
      end
    end
  end
end
