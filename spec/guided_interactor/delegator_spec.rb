module GuidedInteractor

  RSpec.describe Delegator do
    let(:interactor) { Class.new.send(:include, GuidedInteractor) }
    let(:context) { double(:context, foo: 'foo', bar: 'bar') }
    let(:instance) { interactor.new }

    describe 'expects' do
      it 'defines instance delegated methods' do
        expect(GuidedInteractor::Context).to receive(:build) { context }

        interactor.expects(:foo, :bar)

        expect(instance.private_methods).to include(:foo, :bar)
        expect(instance.send(:foo)).to eq 'foo'
        expect(instance.send(:bar)).to eq 'bar'
      end
    end

    describe 'expects!' do
      it 'defines instance delegated methods' do
        expect(interactor).to receive(:expects!).with(:foo, :bar).once
        interactor.expects!(:foo, :bar)
      end

      context 'with parameter missing' do
        let(:context) { double foo: 'foo', bar: nil, called!: double }

        it 'fails the context' do
          expect(GuidedInteractor::Context).to receive(:build) { context }
          expect(context).to receive(:fail!)

          interactor.expects!(:foo, :bar)
          interactor.call
        end
      end

      context 'with all parameters present' do
        let(:context) { double foo: 'foo', bar: 'bar', called!: double }

        it 'does not fail the context' do
          expect(GuidedInteractor::Context).to receive(:build) { context }
          expect(context).not_to receive(:fail!)

          interactor.expects!(:foo, :bar)
          interactor.call
        end
      end
    end

    describe 'mixed delegation' do
      it 'defines instance delegated methods' do
        expect(interactor).to receive(:expects).with(:foo, :bar).once
        expect(interactor).to receive(:expects!).with(:baz, :waldo).once

        interactor.expects(:foo, :bar)
        interactor.expects!(:baz, :waldo)
      end

      context 'with bang parameter missing' do
        let(:context) { double foo: 'foo', baz: 'baz', waldo: nil, called!: double }

        it 'fails the context' do
          expect(GuidedInteractor::Context).to receive(:build) { context }
          expect(context).to receive(:fail!)

          interactor.expects!(:baz, :waldo)
          interactor.call
        end
      end

      context 'with all bang parameters present' do
        let(:context) { double foo: 'foo', baz: 'baz', waldo: 'waldo', called!: double }

        it 'does not fail the context' do
          expect(GuidedInteractor::Context).to receive(:build) { context }
          expect(context).not_to receive(:fail!)

          interactor.expects!(:baz, :waldo)
          interactor.call
        end
      end
    end

    describe 'provides' do
      it 'behaves like expects' do
        expect(GuidedInteractor::Context).to receive(:build) { context }

        interactor.provides(:foo, :bar)

        expect(instance.private_methods).to include(:foo, :bar)
        expect(instance.send(:foo)).to eq 'foo'
        expect(instance.send(:bar)).to eq 'bar'
      end
    end
  end

end
