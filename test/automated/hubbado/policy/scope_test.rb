require_relative "../../../test_init"

context "Hubbado" do
  context "Policy" do
    context "Scope" do
      record = Object.new

      permitted_users_class = Class.new(Hubbado::Policy::Scope) do
        def self.default_scope
          ["user1", "user2"]
        end

        def resolve(_record, scope)
          scope
        end
      end

      test 'uses a default scope of all users' do
        assert permitted_users_class.new.(record) == ["user1", "user2"]
      end

      test 'can be given a scope' do
        scope = ["user1"]

        assert permitted_users_class.new.(record, scope) == scope
      end
    end
  end
end
