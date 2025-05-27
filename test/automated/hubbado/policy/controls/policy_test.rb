require_relative "../../../../test_init"

context "Hubbado" do
  context "Policy" do
    context "Controls" do
      context "Policy" do
        PolicyKlass = Class.new(Hubbado::Policy::Base) do
          define_policy :show do
          end
        end

        ControlPolicyKlass = Class.new do
          def self.example(attributes = nil)
            attributes ||= {}
            Policy.new(**attributes)
          end

          class Policy < Hubbado::Policy::Controls::Policy
            mimic PolicyKlass
          end
        end

        test "uses real value from the policy" do
          mimic_policy = ControlPolicyKlass.example

          refute mimic_policy.show?
        end

        test "mimics passed policy value" do
          mimic_policy = ControlPolicyKlass.example(show: PolicyKlass.permitted)

          assert mimic_policy.show?
        end

        context "DSL Permit" do
          mimic_policy = ControlPolicyKlass.example

          test "permits given policy" do
            mimic_policy.permit(:show)

            assert mimic_policy.show?
          end

          context "with an unknown policy" do
            test "raises an exception" do
              assert_raises(Hubbado::Policy::Controls::Policy::UnkownPolicy) do
                mimic_policy.permit(:unknown)
              end
            end
          end
        end

        context "DSL Deny" do
          mimic_policy = ControlPolicyKlass.example

          test "denies given policy" do
            mimic_policy.deny(:show)

            refute mimic_policy.show?
            assert mimic_policy.show.reason == :denied
          end

          test "provides a reason" do
            mimic_policy.deny(:show, :custom_reason)

            assert mimic_policy.show.reason == :custom_reason
          end

          test "provides data" do
            mimic_policy.deny(:show, data: :custom_data)

            assert mimic_policy.show.data == :custom_data
          end

          context "with an unknown policy" do
            test "raises an exception" do
              assert_raises(Hubbado::Policy::Controls::Policy::UnkownPolicy) do
                mimic_policy.deny(:unknown)
              end
            end
          end
        end
      end
    end
  end
end
