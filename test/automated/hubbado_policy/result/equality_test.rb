require_relative "../../../test_init"

context "HubbadoPolicy" do
  context "Result" do
    context "Equality (==)" do
      permitted = true
      reason = :permitted
      i18n_scope = "some.i18n"

      test "equality is true when permitted and reason are the same instances" do
        result1 = HubbadoPolicy::Result.new(permitted, reason, i18n_scope: i18n_scope)
        result2 = HubbadoPolicy::Result.new(permitted, reason, i18n_scope: i18n_scope)

        assert result1 == result2
      end

      test "equality is false when an instance is a subclass" do
        subclassed_result = Class.new(HubbadoPolicy::Result).new(
          permitted, reason, i18n_scope: i18n_scope
        )

        result = HubbadoPolicy::Result.new(permitted, reason, i18n_scope: i18n_scope)
        assert result != subclassed_result
      end

      test "equality is false when permitted is different" do
        denied = false

        result1 = HubbadoPolicy::Result.new(permitted, reason, i18n_scope: i18n_scope)
        result2 = HubbadoPolicy::Result.new(denied, reason, i18n_scope: i18n_scope)

        assert result1 != result2
      end

      test "equality is false when reason is different" do
        another_reason = :denied

        result1 = HubbadoPolicy::Result.new(permitted, reason, i18n_scope: i18n_scope)
        result2 = HubbadoPolicy::Result.new(permitted, another_reason, i18n_scope: i18n_scope)

        assert result1 != result2
      end
    end
  end
end
