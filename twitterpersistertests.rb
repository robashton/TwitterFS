require 'twitterpersister'

describe TwitterPersister, '#add_tweet' do

  before(:all) do
    @twitter = TwitterPersister.new
    @addedtweetcontent = "Test" + rand(1000).to_s
    @addedid = @twitter.add_tweet(@addedtweetcontent, "Blah")
  end

  it "Adds tweet so it can be retrieved by self" do

    tweet = @twitter.get_tweet(@addedid)

    tweet.content.should == @addedtweetcontent
    tweet.annotation.should == "Blah"
  end
  
  it "Adds tweet so it can be retrieved from twitter" do

    twitter2 = TwitterPersister.new

    tweet = twitter2.get_tweet(@addedid)
    tweet.content.should == @addedtweetcontent
    tweet.annotation.should == "Blah"
  end

  it "means most recent tweet is as expected"  do

      twitter2 = TwitterPersister.new
      tweet = twitter2.get_most_recent_tweet()
      tweet.content.should == @addedtweetcontent
      tweet.annotation.should == "Blah"
  end


  
end