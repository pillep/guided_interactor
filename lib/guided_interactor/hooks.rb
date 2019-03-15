module GuidedInteractor
  module Hooks

    def self.included(base)
      base.class_eval do
        extend ClassMethods
      end
    end

    module ClassMethods

      def around(*hooks, &block)
        hooks << block if block
        hooks.each { |hook| around_hooks.push(hook) }
      end

      def before(*hooks, &block)
        hooks << block if block
        hooks.each { |hook| before_hooks.push(hook) }
      end

      def after(*hooks, &block)
        hooks << block if block
        hooks.each { |hook| after_hooks.unshift(hook) }
      end

      def around_hooks
        @around_hooks ||= []
      end

      def before_hooks
        @before_hooks ||= []
      end

      def after_hooks
        @after_hooks ||= []
      end

    end

    private

      def with_hooks
        run_around_hooks do
          run_before_hooks
          yield
          run_after_hooks
        end
      end

      def run_around_hooks(&block)
        self.class.around_hooks.reverse.reduce(block) do |chain, hook|
          proc { run_hook(hook, chain) }
        end.call
      end

      def run_before_hooks
        run_hooks(self.class.before_hooks)
      end

      def run_after_hooks
        run_hooks(self.class.after_hooks)
      end

      def run_hooks(hooks)
        hooks.each { |hook| run_hook(hook) }
      end

      def run_hook(hook, *args)
        hook.is_a?(Symbol) ? send(hook, *args) : instance_exec(*args, &hook)
      end

  end
end
