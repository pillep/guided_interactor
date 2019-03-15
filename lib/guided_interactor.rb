require 'guided_interactor/version'
require 'guided_interactor/context'
require 'guided_interactor/error'
require 'guided_interactor/hooks'
require 'guided_interactor/organizer'
require 'guided_interactor/delegator'

# Usage
#
#   class MyInteractor
#     include GuidedInteractor
#
#     expects :foo
#     expects! :bar, :baz
#     provides :waldo
#
#     def call
#       context.waldo = 'waldo'
#       puts foo
#       puts waldo
#     end
#   end
module GuidedInteractor

  def self.included(base)
    base.class_eval do
      extend ClassMethods
      include Hooks
      include Delegator

      attr_reader :context
    end
  end

  module ClassMethods

    def call(context = {})
      new(context).tap(&:run).context
    end

    def call!(context = {})
      new(context).tap(&:run!).context
    end

  end

  def initialize(context = {})
    @context = Context.build(context)
  end

  def run
    run!
  rescue Failure
  end

  def run!
    with_hooks do
      call
      context.called!(self)
    end
  rescue StandardError
    context.rollback!
    raise
  end

  def call
  end

  def rollback
  end

end
