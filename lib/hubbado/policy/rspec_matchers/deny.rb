module Hubbado
  module Policy
    module RspecMatchers
      module Deny
        def deny(...)
          DenyMatcher.new(...)
        end

        class DenyMatcher
          def initialize(action, *args, **kwargs)
            @action = action
            @args = args
            @kwargs = kwargs
            @reason = :denied
          end

          def with(reason)
            @reason = reason
            self
          end

          def matches?(policy)
            @policy = policy
            @result = policy.send @action, *@args, **@kwargs

            unless @result.denied?
              @incorrect_repsonse = true
              return false
            end

            if @reason && @result.reason != @reason
              @incorrect_reason = true
              return false
            end

            begin
              @result.message
            rescue I18n::MissingTranslationData
              @missing_translation = true
              return false
            end

            true
          end

          def description
            "#{@policy.class.name} deny #{@action} with #{@reason}"
          end

          def failure_message
            if @incorrect_reason
              "Expected #{@policy.class.name} to deny #{@action}, with #{@reason} " \
                "but it was denied with #{@result.reason}"
            elsif @missing_translation
              "Translation missing for policy #{@policy.class.name} and #{@reason}"
            else
              "Expected #{@policy.class.name} to deny #{@action}, but it was permitted"
            end
          end

          def failure_message_when_negated
            if @missing_translation
              "Translation missing for policy #{@policy.class.name} and #{@reason}"
            else
              "Expected #{@policy.class.name} to permit #{@action}, but it was denied"
            end
          end
        end

        RSpec.configure do |rspec|
          rspec.include self, type: :policy
        end
      end
    end
  end
end
