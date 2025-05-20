module Hubbado
  module Policy
    module Controls
      class Policy
        def self.mimic(policy_class)
          policy_class.policies.each do |policy|
            send(:attr_writer, policy)

            define_method policy do
              instance_variable_get("@#{policy}") || Policy::Base.denied
            end

            define_method "#{policy}?" do
              send(policy).permitted?
            end
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
