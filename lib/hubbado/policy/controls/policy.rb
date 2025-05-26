module Hubbado
  module Policy
    module Controls
      class Policy
        UnkownPolicy = Class.new(StandardError)

        def self.mimic(policy_class)
          policy_class.policies.each do |policy|
            send(:attr_writer, policy)

            define_method policy do
              instance_variable_get("@#{policy}") || ::Hubbado::Policy::Base.denied
            end

            define_method "#{policy}?" do
              send(policy).permitted?
            end
          end

          define_method :permit do |policy|
            unless policy_class.instance_variable_get("@policies").include?(policy)
              raise UnkownPolicy
            end

            send("#{policy}=", policy_class.permitted)
          end

          define_method :deny do |policy, reason = nil, data: nil|
            unless policy_class.instance_variable_get("@policies").include?(policy)
              raise UnkownPolicy
            end

            send("#{policy}=", policy_class.denied(reason, data: data))
          end
        end

        def initialize(policies = {})
          policies.each do |policy, result|
            send("#{policy}=", result)
          end
        end
      end
    end
  end
end
