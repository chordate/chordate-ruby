require "spec_helper"

describe Chordate do
  describe '.configure' do
    it 'should yield a Config object' do
      Chordate.configure {|c| c.class.should == Chordate::Config }
    end

    it 'should cache the object' do
      configs = []
      Chordate.configure {|c| configs << c }
      Chordate.configure {|c| configs << c }

      configs[0].should == configs[1]
    end
  end

  describe '.config' do
    before do
      Chordate.configure {|c| c.foo = 'bar' }
    end

    it 'should be the config object' do
      Chordate.config.class.should == Chordate::Config
    end

    it 'should have the options' do
      Chordate.config.foo.should == 'bar'
    end
  end

  describe '.run!' do
    before do
      @event_runner = mock(Chordate::Runner::Event, :start => nil, :terminate => nil)
      Chordate::Runner::Event.stub(:new).and_return(@event_runner)
    end

    after do
      Chordate.send(:clear)
    end

    it 'should build the runner' do
      Chordate::Runner::Event.should_receive(:new).and_return(@event_runner)

      Chordate.run!
    end

    it 'should start the runner' do
      @event_runner.should_receive(:start)

      Chordate.run!
    end

    it "should be running" do
      Chordate.run!

      Chordate.should be_running
    end
  end

  describe '.error' do
    let(:exception) { make_exception }
    let(:options) { {} }

    def error
      Chordate.error(exception, options)
    end

    before do
      @async = mock(Celluloid::ActorProxy, :push => nil)
      @runner = mock(Chordate::Runner::Event, :start => nil, :async => @async, :terminate => nil)
      Chordate::Runner::Event.stub(:new).and_return(@runner)

      Chordate.run!

      @json = mock("JSON")
      @error = mock(Chordate::Error, :as_json => @json)
      Chordate::Error.stub(:new).and_return(@error)
    end

    after do
      Chordate.send(:clear)
    end

    it 'should init an error' do
      Chordate::Error.should_receive(:new).with(exception, options).and_return(@error)

      error
    end

    it 'should push the error to the runner' do
      @async.should_receive(:push).with(@json)

      error
    end
  end
end
