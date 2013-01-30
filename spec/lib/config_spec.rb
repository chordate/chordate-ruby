require 'spec_helper'

describe Chordate::Config do
  [[:a_key, '123:abcdef']].each do |(method, value)|
    describe "##{method}" do
      before do
        subject.send("#{method}=", value)
      end

      it 'should store the given value' do
        subject[method].should == value
      end

      it "should have the value at ##{method}" do
        subject.send(method).should == value
      end
    end
  end

  describe '#token=' do
    before do
      subject.token = '789:the-token'
    end

    it 'should have the token' do
      subject.token.should == 'the-token'
    end

    it 'should have the id in the base url' do
      subject.base_url.should match(/applications\/789$/)
    end
  end

  describe 'defaults' do
    subject { Chordate.config }

    it 'should have the gem version' do
      subject.server[:gem_version].should == Chordate::Version::STRING
    end

    it 'should have the hostname' do
      subject.server[:hostname].should == `hostname`.chomp
    end

    it 'should have the root' do
      subject.server[:root].should == `pwd`.chomp
    end

    it 'should have the environment' do
      subject.env.should == 'the-environment'
    end

    it 'should have the base_url' do
      subject.base_url.should == '/v1/applications/123'
    end
  end
end
