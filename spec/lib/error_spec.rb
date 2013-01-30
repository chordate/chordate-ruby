require 'spec_helper'

describe Chordate::Error do
  describe '#as_json' do
    let(:options) { {} }

    describe "for an exception" do
      let(:exception) { make_exception }

      def json
        Chordate::Error.new(exception, options).as_json
      end

      it 'should extract the error class' do
        json[:klass].should == 'RuntimeError'
      end

      it 'should extract the error message' do
        json[:message].should == 'BOOM!'
      end

      it 'should extract the error backtrace' do
        json[:backtrace].should == exception.backtrace
      end

      describe 'server' do
        it 'should have the gem version' do
          json[:server][:gem_version].should == Chordate::Version::STRING
        end

        it 'should have the hostname' do
          json[:server][:hostname].should == Chordate.config.server[:hostname]
        end

        it 'should have the app root' do
          json[:server][:root].should == Chordate.config.server[:root]
        end
      end

      describe 'when given options' do
        before do
          options[:extra] = { :data => 'attr' }
        end

        it 'should have the options' do
          json[:extra][:data].should == 'attr'
        end
      end
    end
  end

  describe "merge!" do
    let(:options) { { :key => 'value', :other => 3, :env => nil } }
    let(:exception) { make_exception }

    subject { Chordate::Error.new(exception, {}) }

    def merge!
      subject.merge!(options)
    end

    it 'should return itself' do
      merge!.should == subject
    end

    it 'should add to the keys' do
      merge!.as_json[:key].should == 'value'
      merge!.as_json[:other].should == 3
    end

    it 'should remove keys with nil values' do
      merge!.as_json.keys.should_not include(:env)
    end
  end
end
