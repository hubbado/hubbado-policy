require_relative "../../../../test_init"

context "Hubbado" do
  context "Policy" do
    context "Base" do
      context "Result" do
        context "#permitted?" do
          test "builds a Result permitted object" do
            permitted_result = Hubbado::Policy::Base.permitted
            result = Hubbado::Policy::Result.new(true, :permitted)

            assert permitted_result == result
          end
        end

        context "#denied?" do
          test "builds a Result denied object" do
            denied_result = Hubbado::Policy::Base.denied
            result = Hubbado::Policy::Result.new(false, :denied)

            assert denied_result == result
          end

          test "builds a Result denied object with custom reason" do
            denied_result = Hubbado::Policy::Base.denied(:custom_reason)
            result = Hubbado::Policy::Result.new(false, :custom_reason)

            assert denied_result == result
          end
        end
      end
    end
  end
end
