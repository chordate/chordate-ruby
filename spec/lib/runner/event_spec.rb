require 'spec_helper'

describe Chordate::Runner::Event do
  describe '#start' do
    def start
      subject.exit; subject.start
    end

    describe 'when there are waiting errors' do
      let(:errors) do
        [
          { :klass => 'RuntimeError' },
          { :klass => 'OtherError' }
        ]
      end

      before do
        subject.push(errors.first)
        subject.push(errors.last)
      end

      it 'should have the errors' do
        subject.errors.should == errors
      end

      it 'should post to events' do
        Chordate::HTTP.should_receive(:post).with(:events, anything)

        start
      end

      it 'should process the errors' do
        Chordate::HTTP.should_receive(:post).with(anything, :batch => errors)

        start
      end

      it 'should clear the errors' do
        start

        subject.errors.should == []
      end
    end
  end
end
