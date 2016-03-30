require_relative '../bench_init'

context "Post Substitute" do
  context "Response" do
    context "Assignable" do
      substitute_post = HTTP::Commands::Post::Substitute.build

      substitute_post.status_code = 'some-status-code'
      substitute_post.reason_phrase = 'some-reason-phrase'
      substitute_post.response_body = 'some-response-body'

      response = substitute_post.()

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
      substitute_post = HTTP::Commands::Post::Substitute.build
      response = substitute_post.()

      context "Status Code" do
        control_status_code = 201

        test control_status_code do
          assert response.status_code == control_status_code
        end
      end

      context "Reason Phrase" do
        control_reason_phrase = 'Created'

        test control_reason_phrase do
          assert response.reason_phrase == control_reason_phrase
        end
      end
    end
  end
end
