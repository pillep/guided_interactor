require 'ostruct'

module GuidedInteractor
  class Context < OpenStruct

    def self.build(context = {})
      self === context ? context : new(context)
    end

    def success?
      !failure?
    end

    def failure?
      @failure || false
    end

    def fail!(context = {})
      context.each { |key, value| modifiable[key.to_sym] = value }
      @failure = true
      raise Failure, self
    end

    def called!(interactor)
      _called << interactor
    end

    def rollback!
      return false if @rolled_back

      _called.reverse_each(&:rollback)
      @rolled_back = true
    end

    def _called
      @called ||= []
    end

  end
end
