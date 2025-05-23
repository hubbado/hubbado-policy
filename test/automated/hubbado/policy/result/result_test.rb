require_relative "../../../../test_init"

context "Hubbado" do
  context "Policy" do
    context "Result" do
      context "#data" do
        test "data is an empty hash" do
          result = Hubbado::Policy::Result.new(true, :permitted)

          assert result.data == {}
        end

        test "with custom info sets data" do
          result = Hubbado::Policy::Result.new(true, :permitted, data: "custom_data")

          assert result.data == "custom_data"
        end
      end

      context "#permitted?" do
        test "returns true when permitted" do
          result = Hubbado::Policy::Result.new(true, :permitted)

          assert result.permitted?
        end

        test "returns false when not permitted" do
          result = Hubbado::Policy::Result.new(false, :permitted)

          refute result.permitted?
        end
      end

      context "#denied?" do
        test "returns true when denied" do
          result = Hubbado::Policy::Result.new(false, :denied)

          assert result.denied?
        end

        test "returns false when not denied" do
          result = Hubbado::Policy::Result.new(true, :denied)

          refute result.denied?
        end
      end

      context "#reason" do
        test "returns the reason given" do
          reason = :some_reason
          result = Hubbado::Policy::Result.new(false, :some_reason)

          assert result.reason == reason
        end
      end

      context "#generic_deny" do
        test "is true when denied reason is generic" do
          result = Hubbado::Policy::Result.new(false, :denied)

          assert result.generic_deny?
        end

        test "is false when denied reason is given" do
          result = Hubbado::Policy::Result.new(false, :some_reason)

          refute result.generic_deny?
        end
      end

      context "#message" do
        test "nothing when permitted" do
          result = Hubbado::Policy::Result.new(true, :permitted)

          assert result.message.nil?
        end

        test "generic denied message" do
          result = Hubbado::Policy::Result.new(false, :denied)

          assert result.message == "error denied message"
        end

        test "custom denied message" do
          result = Hubbado::Policy::Result.new(false, :blank)

          assert result.message == "blank error"
        end

        test "custom denied message with i18n scope" do
          result = Hubbado::Policy::Result.new(false, :blank, i18n_scope: "errors.custom_error")

          assert result.message == "custom blank error"
        end
      end
    end
  end
end
