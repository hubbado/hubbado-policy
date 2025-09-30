module Hubbado
  module Policy
    module RspecMatchers
      module Permit
        def permit(...)
          PermitMatcher.new(...)
        end

        class PermitMatcher
          def initialize(action, *args, **kwargs)
            @action = action
            @args = args
            @kwargs = kwargs
          end

          def matches?(policy)
            @policy = policy

            if policy.respond_to?(@action)
              @result = policy.send @action, *@args, **@kwargs

              @result.permitted?
            else
              # TODO: Get rid of this branch once the Navigation policy uses the DSL
              policy.send "#{@action}?", *@args, **@kwargs
            end
          end

          def description
            "#{@policy.class.name} permit #{@action}"
          end

          def failure_message
            "Expected #{@policy.class.name} to permit #{@action}, " \
              "but it was revoked with #{@reason ? @result.reason : 'no reason'}"
          end

          def failure_message_when_negated
            "Expected #{@policy.class.name} to deny #{@action}, but it was permitted"
          end
        end

        RSpec.configure do |rspec|
          rspec.include self, type: :policy
        end
      end
    end
  end
end
