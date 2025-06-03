require_relative "../../../../test_init"

context "Hubbado" do
  context "Policy" do
    context "Base" do
      context "I18n Scope" do
        test "denied class method uses a custom i18n_scope" do
          permitted_result = Hubbado::Policy::Base.denied(:blank, i18n_scope: "errors.custom_error")

          assert permitted_result.message == "custom blank error"
        end

        test "denied instance method uses a custom i18n_scope" do
          user = Object.new
          record = Object.new
          policy = Hubbado::Policy::Base.new(user, record)
          permitted_result = policy.denied(:blank, i18n_scope: "errors.custom_error")

          assert permitted_result.message == "custom blank error"
        end
      end
    end
  end
end
