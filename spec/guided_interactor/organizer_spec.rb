module GuidedInteractor

  describe Organizer do
    include_examples :lint

    let(:organizer) { Class.new.send(:include, Organizer) }

    describe '.organize' do
      let(:interactor2) { double(:interactor2) }
      let(:interactor3) { double(:interactor3) }

      it 'sets interactors given class arguments' do
        expect do
          organizer.organize(interactor2, interactor3)
        end.to change {
          organizer.organized
        }.from([]).to([interactor2, interactor3])
      end

      it 'sets interactors given an array of classes' do
        expect do
          organizer.organize([interactor2, interactor3])
        end.to change {
          organizer.organized
        }.from([]).to([interactor2, interactor3])
      end
    end

    describe '.organized' do
      it 'is empty by default' do
        expect(organizer.organized).to eq([])
      end
    end

    describe '#call' do
      let(:instance) { organizer.new }
      let(:context) { double(:context) }
      let(:interactor2) { double(:interactor2) }
      let(:interactor3) { double(:interactor3) }
      let(:interactor4) { double(:interactor4) }

      before do
        allow(instance).to receive(:context) { context }
        allow(organizer).to receive(:organized) {
          [interactor2, interactor3, interactor4]
        }
      end

      it 'calls each interactor in order with the context' do
        expect(interactor2).to receive(:call!).once.with(context).ordered
        expect(interactor3).to receive(:call!).once.with(context).ordered
        expect(interactor4).to receive(:call!).once.with(context).ordered

        instance.call
      end
    end
  end

end
