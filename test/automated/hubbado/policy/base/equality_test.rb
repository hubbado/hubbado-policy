require_relative "../../../../test_init"

context "Hubbado" do
  context "Policy" do
    context "Base" do
      context "Equality (==)" do
        user = Object.new
        record = Object.new

        test "equality is true when user and record are the same objects between instances" do
          policy1 = Hubbado::Policy::Base.new(user, record)
          policy2 = Hubbado::Policy::Base.new(user, record)

          assert policy1 == policy2
        end

        test "equality is false when an instance is a subclass" do
          subclassed_policy = Class.new(Hubbado::Policy::Base).new(user, record)

          policy = Hubbado::Policy::Base.new(user, record)
          assert policy != subclassed_policy
        end

        test "equality is false when users are differents" do
          user1 = Object.new
          user2 = Object.new
          policy1 = Hubbado::Policy::Base.new(user1, record)
          policy2 = Hubbado::Policy::Base.new(user2, record)

          assert policy1 != policy2
        end

        test "equality is false when records are differents" do
          record1 = Object.new
          record2 = Object.new
          policy1 = Hubbado::Policy::Base.new(user, record1)
          policy2 = Hubbado::Policy::Base.new(user, record2)

          assert policy1 != policy2
        end
      end
    end
  end
end
