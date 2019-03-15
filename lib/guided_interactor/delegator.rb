module GuidedInteractor
  module Delegator

    def self.included(base)
      base.class_eval do
        extend ClassMethods
      end
    end

    module ClassMethods

      def expects(*params)
        params.each do |param|
          define_method param do
            context.public_send(param)
          end
          private param
        end
      end

      def expects!(*params)
        expects(*params)

        before do
          params.each do |param|
            context.fail! if context.public_send(param).nil?
          end
        end
      end

      alias_method :provides, :expects

    end

  end
end
