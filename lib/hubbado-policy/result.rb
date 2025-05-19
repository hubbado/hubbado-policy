module HubbadoPolicy
  class Result
    attr_reader :reason

    def initialize(permitted, reason, i18n_scope = nil)
      i18n_scope ||= "hubbado_policy"

      @permitted = permitted
      @reason = reason
      @i18n_scope = i18n_scope
    end

    def permitted?
      !!@permitted
    end

    def denied?
      !@permitted
    end

    def generic_deny?
      @reason == :denied
    end

    def message
      return if permitted?
      return I18n.t('hubbado_policy.errors.denied') if generic_deny?
      I18n.t(@reason, scope: @i18n_scope)
    end

    def ==(other)
      self.class == other.class && permitted? == other.permitted? && @reason == other.reason
    end
  end
end
