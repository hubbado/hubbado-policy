module Hubbado
  module Policy
    class Base
      module PolicyDSL
        def self.included(klass)
          klass.extend(ClassMethods)
        end

        module ClassMethods
          def inherited(subclass)
            super
            # Copy policies from parent class to subclass
            subclass.instance_variable_set(:@policies, @policies&.dup || Set.new)
          end

          def define_policy(policy, *args, **kwargs, &block)
            @policies ||= Set.new
            @policies << policy

            # NOTE: This uses the technique described here so that the block given to
            # define_policy can have return statements without causing LocalJumpError
            #   http://blog.jayfields.com/2007/03/ruby-localjumperror-workaround.html
            define_method policy, &block
            new_method = instance_method(policy)
            define_method policy do |*args, **kwargs|
              new_method.bind(self).call(*args, **kwargs) || denied
            end

            define_method "#{policy}?" do |*args, **kwargs|
              send(policy, *args, **kwargs).permitted?
            end
          end

          attr_reader :policies
        end
      end

      include PolicyDSL

      attr_reader :user, :record

      def self.build(user, record)
        instance = new(user, record)
        instance.configure
        instance
      end

      # Define this in a subclass if there are dependencies to be configure
      template_method :configure

      def self.denied(reason = nil, data: nil, i18n_scope: nil)
        i18n_scope ||= self.i18n_scope
        reason ||= :denied
        Result.new(false, reason, i18n_scope: i18n_scope, data: data)
      end

      def self.permitted
        Result.new(true, :permitted)
      end

      def self.i18n_scope
        @i18n_scope ||= Casing::Underscore::String.(name).gsub('/', '.')
      end

      def initialize(user, record)
        raise "User not provided" unless user

        @user = user
        @record = record
      end

      def ==(other)
        self.class == other.class && user == other.user && record == other.record
      end

      def denied(reason = nil, data: nil, i18n_scope: nil)
        self.class.denied(reason, data: data, i18n_scope: i18n_scope)
      end

      def permitted
        self.class.permitted
      end
    end
  end
end
