require 'breaker_box/storage/memory'

describe BreakerBox::Storage::Memory do

  let(:time) { Time.utc(2014,4,10,10,5,1) }
  let(:one_hour_ago) { time - 3600 }
  subject { described_class.new }

  it "stores the time" do
    expect {
      subject.fail!(time)
    }.to change{ subject.count }.by(1)
  end

  it "clears the failures" do
    subject.fail!(one_hour_ago)
    subject.fail!(time)

    expect {
      subject.clear!
    }.to change{ subject.count }.by(-2)
  end

  it "gets the last failure time" do
    subject.fail!(one_hour_ago)
    subject.fail!(time)    
    subject.last_failure_time.should == time
  end

  it "gets the failure times in a given time span" do
    subject.fail!(one_hour_ago)
    subject.fail!(time)    
    subject.all_since(time - 60).should == [time]
    subject.all_since(one_hour_ago - 60).should == [one_hour_ago, time]
  end

end
