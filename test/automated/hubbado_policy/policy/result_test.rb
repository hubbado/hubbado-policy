require_relative "../../../test_init"

context "HubbadoPolicy" do
  context "Policy" do
    context "#permitted?" do
      test "builds a Result permitted object" do
        permitted_result = HubbadoPolicy::Policy.permitted
        result = HubbadoPolicy::Result.new(true, :permitted)

        assert permitted_result == result
      end
    end

    context "#denied?" do
      test "builds a Result denied object" do
        denied_result = HubbadoPolicy::Policy.denied
        result = HubbadoPolicy::Result.new(false, :denied)

        assert denied_result == result
      end

      test "builds a Result denied object with custom reason" do
        denied_result = HubbadoPolicy::Policy.denied(:custom_reason)
        result = HubbadoPolicy::Result.new(false, :custom_reason)

        assert denied_result == result
      end
    end
  end
end
