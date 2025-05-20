require_relative "../../../../test_init"

context "Hubbado" do
  context "Policy" do
    context "Result" do
      context "Equality (==)" do
        permitted = true
        reason = :permitted
        i18n_scope = "some.i18n"

        test "equality is true when permitted and reason are the same instances" do
          result1 = Hubbado::Policy::Result.new(permitted, reason, i18n_scope: i18n_scope)
          result2 = Hubbado::Policy::Result.new(permitted, reason, i18n_scope: i18n_scope)

          assert result1 == result2
        end

        test "equality is false when an instance is a subclass" do
          subclassed_result = Class.new(Hubbado::Policy::Result).new(
            permitted, reason, i18n_scope: i18n_scope
          )

          result = Hubbado::Policy::Result.new(permitted, reason, i18n_scope: i18n_scope)
          assert result != subclassed_result
        end

        test "equality is false when permitted is different" do
          denied = false

          result1 = Hubbado::Policy::Result.new(permitted, reason, i18n_scope: i18n_scope)
          result2 = Hubbado::Policy::Result.new(denied, reason, i18n_scope: i18n_scope)

          assert result1 != result2
        end

        test "equality is false when reason is different" do
          another_reason = :denied

          result1 = Hubbado::Policy::Result.new(permitted, reason, i18n_scope: i18n_scope)
          result2 = Hubbado::Policy::Result.new(permitted, another_reason, i18n_scope: i18n_scope)

          assert result1 != result2
        end
      end
    end
  end
end
