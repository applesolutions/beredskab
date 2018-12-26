require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = 'QcYvAtdUnRiriKX1yeWLlGjQf'
  config.consumer_secret = 'O1831gZAhZRWG1tE0oka3XdLVshsfVAGvcRlcQJAT7tmo9Gvyl'
  config.access_token = '945899959680978944-WQKsZ7bHtku9fNKdISAS1dTN5QJToHp'
  config.access_token_secret = 'CMPK5p9daK9lYOTlsE487ABs3ZECBH5WUBLoz7gLj2DiC'
end

search_term = URI::encode('#hberedskab,politidk')

SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{search_term}")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end