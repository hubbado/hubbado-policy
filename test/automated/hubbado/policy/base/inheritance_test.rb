require_relative "../../../../test_init"

context "Hubbado" do
  context "Policy" do
    context "Base" do
      context "Inheritance" do
        GrandeParent = Class.new(Hubbado::Policy::Base) do
          define_policy :create do
            permitted
          end

          define_policy :show do
            permitted
          end
        end

        ParentPolicy = Class.new(GrandeParent) do
          define_policy :create do
            denied
          end
        end

        ChildPolicy = Class.new(ParentPolicy) do
          define_policy :show do
            denied
          end
        end

        user = Object.new
        record = Object.new

        parent_policy = ParentPolicy.build(user, record)
        child_policy = ChildPolicy.build(user, record)

        test "overwrites policy definition" do
          refute parent_policy.create?
          refute child_policy.show?
        end

        test "uses policy defined in parent class" do
          assert parent_policy.show?
          refute child_policy.create?
        end

        test "inherits policies class instance variable" do
          assert ParentPolicy.policies.sort == %i[create show].sort
          assert ChildPolicy.policies.sort == %i[create show].sort
        end
      end
    end
  end
end
