require_relative "../../../test_init"

context "HubbadoPolicy" do
  context "Result" do
    context "#permitted?" do
      test "returns true when permitted" do
        result = HubbadoPolicy::Result.new(true, :permitted)

        assert result.permitted?
      end

      test "returns false when not permitted" do
        result = HubbadoPolicy::Result.new(false, :permitted)

        assert !result.permitted?
      end
    end

    context "#denied?" do
      test "returns true when denied" do
        result = HubbadoPolicy::Result.new(false, :denied)

        assert result.denied?
      end

      test "returns false when not denied" do
        result = HubbadoPolicy::Result.new(true, :denied)

        assert !result.denied?
      end
    end

    context "#reason" do
      test "returns the reason given" do
        reason = :some_reason
        result = HubbadoPolicy::Result.new(false, :some_reason)

        assert result.reason == reason
      end
    end

    context "#generic_deny" do
      test "is true when denied reason is generic" do
        result = HubbadoPolicy::Result.new(false, :denied)

        assert result.generic_deny?
      end

      test "is false when denied reason is given" do
        result = HubbadoPolicy::Result.new(false, :some_reason)

        refute result.generic_deny?
      end
    end

    context "#message" do
      test "generic denied message" do
        result = HubbadoPolicy::Result.new(false, :denied)

        assert result.message == "error denied message"
      end

      test "custom denied message" do
        result = HubbadoPolicy::Result.new(false, :blank)

        assert result.message == "blank error"
      end

      test "custom denied message with i18n scope" do
        result = HubbadoPolicy::Result.new(false, :blank, "custom_error")

        assert result.message == "custom blank error"
      end
    end
  end
end
