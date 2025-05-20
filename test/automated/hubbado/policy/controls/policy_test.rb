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

          class Policy < ::Hubbado::Policy::Controls::Policy
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
      end
    end
  end
end
