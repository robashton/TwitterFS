require 'twitter'
require 'json'
require 'twitterfspersistance'

class TwitterPersister

  def initialize()

      @oauth   = Twitter::OAuth.new("PFMwwMtecIOh7KkMvFTFg", "7MvHe8dxFwpS3AWbN2Eet59TNB3yoIyylc98K32K4s")
      @rtoken  = @oauth.request_token.token
      @rsecret = @oauth.request_token.secret
      @oauth.authorize_from_access("154870361-btax28y7SIboCTTwb44QlAMM8eEIMnLkFiURTwUi", "LKKHLI0hsmdhwofMHhAnqCWrXjVW3tL65pQ4t8oXbg")

      @twitter = Twitter::Base.new(@oauth)
      @cache = Array.new

  end

  def add_tweet(tweet, annotation)
      added =  @twitter.update(tweet + "@~" + annotation)
      addedtweet = Tweet.new(added.id, tweet, annotation)

      @cache << addedtweet
      addedtweet.uid
  end

  def get_tweet(uid)

    @cache.each() { |t|
      if(t.uid == uid)
        return t
      end
    }

    add_to_cache(uid)
    get_tweet(uid)
  end

  def get_most_recent_tweet()

    @cache = Array.new
    add_to_cache(0)
    
    highesttweet = @cache[0]
    @cache.each() { |t|
      if(t.uid > highesttweet.uid)
        highesttweet = t
      end
    }
    return highesttweet

  end


  def add_to_cache(startid)
    timeline = @twitter.user_timeline({"since_id" => startid-1})
    timeline.each() { |t|

      splittweet = t.text.split(/@~/)

      addedtweet = Tweet.new(t.id, splittweet[0], splittweet[1])
         @cache << addedtweet
    }
  end
  

end