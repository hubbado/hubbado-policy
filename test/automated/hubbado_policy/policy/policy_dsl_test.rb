require_relative "../../../test_init"

context "HubbadoPolicy" do
  context "Policy" do
    context "PolicyDSLTest" do
      user = Object.new
      record = Object.new

      test 'can define a policy that returns a custom denied reason' do
        policy_class = Class.new(Policy) do
          def self.name
            'TestPolicy'
          end

          define_policy :test_action do
            denied(:my_reason)
          end
        end

        policy = policy_class.new(user, record)

        result = HubbadoPolicy::Result.new(false, :my_reason)

        refute policy.test_action?
        assert policy.test_action == result
      end

      test 'returns denied by default' do
        policy_class = Class.new(Policy) do
          def self.name
            'TestPolicy'
          end

          define_policy :test_action do
            permitted if 1 == 2 # This will always fail
          end
        end

        policy = policy_class.new(user, record)

        refute policy.test_action?
      end

      test 'can use return statements in the policy DSL' do
        policy_class = Class.new(Policy) do
          def self.name
            'TestPolicy'
          end

          define_policy :test_action do
            return permitted if true
            denied
          end
        end

        policy = policy_class.new(user, record)

        assert policy.test_action?
      end

      context 'with a policy action that takes an argument' do
        policy_class = Class.new(Policy) do
          def self.name
            'TestPolicy'
          end

          define_policy :test_action do |arg|
            permitted if arg == :pass
          end
        end

        policy = policy_class.new(user, record)

        test 'builds boolean methods accept the argument' do
          assert policy.test_action?(:pass)
          refute policy.test_action?(:fail)

          assert_raises ArgumentError, "wrong number of arguments (given 0, expected 1)" do
            policy.test_action?
          end
        end

        test 'builds policy methods that accept the argument' do
          assert policy.test_action?(:pass)
          refute policy.test_action?(:fail)

          assert_raises ArgumentError, "wrong number of arguments (given 0, expected 1)" do
            policy.test_action
          end
        end
      end

      context 'with a policy action that takes an keyword argument' do
        policy_class = Class.new(Policy) do
          def self.name
            'TestPolicy'
          end

          define_policy :test_action do |kwarg:|
            permitted if kwarg == :pass
          end
        end

        policy = policy_class.new(user, record)

        test 'builds boolean methods accept the argument' do
          assert policy.test_action?(kwarg: :pass)
          refute policy.test_action?(kwarg: :fail)

          assert_raises ArgumentError, "missing keyword: :kwarg" do
            policy.test_action?
          end
        end

        test 'builds policy methods that accept the argument' do
          assert policy.test_action(kwarg: :pass).permitted?
          refute policy.test_action(kwarg: :fail).permitted?

          assert_raises ArgumentError, "missing keyword: :kwarg" do
            policy.test_action
          end
        end
      end
    end
  end
end
