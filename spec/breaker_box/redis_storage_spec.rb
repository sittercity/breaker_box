require 'spec_helper'
require 'breaker_box/redis_storage'

describe BreakerBox::RedisStorage do

  let(:key) { double(:key) }
  let(:redis) { double(:redis, get: nil, set: nil) }
  let(:time) { Time.new(2014,4,10,10,5,1).utc }
  let(:one_hour_ago) { time - 3600 }

  subject { described_class.new(redis,key) }

  it "creates a new array and stores it in redis" do
    subject.should_receive(:set_storage).with([time])
    subject.fail!(time)
  end

  it "should update the existing object if it's already present" do
    subject.stub(:get_storage).and_return([one_hour_ago])
    subject.should_receive(:set_storage).with([one_hour_ago, time])
    subject.fail!(time)
  end

  it "clears the redis object" do
    subject.should_receive(:set_storage).with([])
    subject.clear!
  end

  it "gets the last failure time" do
    subject.stub(:get_storage).and_return([one_hour_ago])
    subject.last_failure_time.should == one_hour_ago
  end

  it "gets the failure times in a given time span" do
    thirty_mins_ago = time - 1800
    two_hours_ago = time - 7200
    subject.stub(:get_storage).and_return([one_hour_ago,time])
    subject.all_since(thirty_mins_ago).should == [time]
    subject.all_since(two_hours_ago).should == [one_hour_ago,time]
  end
end
