require 'spec_helper'
require 'breaker_box/redis_storage'

describe BreakerBox::RedisStorage do

  let(:key) { double(:key) }
  let(:redis) { double(:redis, rpush: nil, del: nil) }
  let(:time) { Time.utc(2014,4,10,10,5,1) }
  let(:one_hour_ago) { time - 3600 }

  subject { described_class.new(redis,key) }

  it "stores the time" do
    redis.should_receive(:rpush).with(key,"2014-04-10 10:05:01 UTC")
    subject.fail!(time)
  end

  it "clears the redis object" do
    redis.should_receive(:del).with(key)
    subject.clear!
  end

  it "gets the last failure time" do
    redis.stub(:lindex).and_return(one_hour_ago)
    subject.last_failure_time.should == one_hour_ago
  end

  it "gets the failure times in a given time span" do
    thirty_mins_ago = time - 1800
    two_hours_ago = time - 7200
    redis.stub(:get).and_return([one_hour_ago,time])
    subject.all_since(thirty_mins_ago).should == [time]
    subject.all_since(two_hours_ago).should == [one_hour_ago,time]
  end
end
