require 'spec_helper'

describe Chordate::HTTP do
  describe '.post' do
    let(:body) { { :key => 'value' } }

    def post
      Chordate::HTTP.post(:something_special, body)
    end

    before do
      Chordate::HTTP.rspec_reset
    end

    it 'should post to the given path' do
      Typhoeus.should_receive(:post).with('https://chordate.io/v1/applications/123/something_special.json', anything)

      post
    end

    it 'should pass the given body' do
      Typhoeus.should_receive(:post) do |_, options|
        options[:body][:key].should  == 'value'
      end

      post
    end

    describe 'defaults' do
      it 'should send the token' do
        Typhoeus.should_receive(:post) do |_, options|
          options[:body][:token].should == Chordate.config.token
        end

        post
      end
    end
  end
end
