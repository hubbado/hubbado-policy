module HubbadoPolicy
  class Scope
    class << self
      # Define this in a subclass
      template_method :default_scope
    end

    def self.call(record, scope = nil, **options)
      build.(record, scope, **options)
    end

    def self.build
      instance = new
      instance.configure
      instance
    end

    # Define this in a subclass if there are dependencies to be configure
    template_method :configure

    def call(record, scope = nil, **options)
      scope ||= self.class.default_scope

      resolve(record, scope, **options)
    end

    # Implement this in a subclass
    template_method :resolve do |_record, _scope, **_options|
      raise MethodMissing
    end

    module Substitute
      include RecordInvocation

      attr_writer :result

      record def call(record, scope = nil, **options) = result

      def result
        @result ||= []
      end

      def called?(record, scope = nil, **options)
        invoked?(:call, record: record, scope: scope, options: options)
      end
    end
  end
end
