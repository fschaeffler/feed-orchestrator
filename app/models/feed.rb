require 'rss'
require 'fastimage'

class Feed

  def self.get_feed(network)
    time = Time.now
    source = feed_source
    feed = source.clone
 
    if (network == 'test') || (include_post?(network, time) && source.channel.items.length > 0)
      post = select_post(source.channel.items)

      50.times.each do puts select_post(source.channel.items).link end

      post.link << '?utm_source=' << network.to_s << '&utm_medium=feed_orchestrator&utm_content=' << time.strftime("%Y-%m-%d_%H")  << '&utm_campaign=' << time.wday.to_s << '-' << time.hour.to_s
      post.comments = "Republish: " + DateTime.parse(time.strftime("%Y-%m-%d %H")).rfc2822
      enclosure_url = post.enclosure.url
      enclosure_type = post.enclosure.type
      post.enclosure = RSS::Rss::Channel::Item::Enclosure.new
      post.enclosure.url = enclosure_url
      post.enclosure.type = enclosure_type
      post.enclosure.length = FastImage.new(enclosure_url).content_length

      feed.items.clear
      feed.items << post
    else
      feed.items.clear
    end

    feed
  end

  private

  def self.include_post?(network, time)
    timings = posting_times[network]

    if timings && timings.has_key?(time.wday)
      if timings[time.wday].include?(time.hour)
        return true
      end
    end

    false
  end

  def self.select_post(posts)
    # exclude 'hello world'-post
    hello_world = posts.select { |s| s.link == 'http://aws-blog.io/2015/stay-tuned/'}.first
    posts.delete(hello_world)

    no_posts = posts.length
    base_value = 500 / no_posts
    index = no_posts.times
      .collect { |entry| [no_posts - entry - 1, entry * base_value + Random.rand(500)] }
      .sort! { |left,right| left[1] <=> right[1] }
      .last[0]

    posts[index]
  end

  def self.feed_base(source)
    rss = RSS::Maker.make("atom") do |maker|
      maker.channel.description = source.channel.description
      maker.channel.link = source.channel.link
      maker.channel.title = source.channel.title
      maker.channel.language = source.channel.language
      maker.channel.updated = Time.now.to_s
      maker.channel.author = "flo@aws-blog.io"
      maker.channel.about = 'http://aws-blog.io/feed.xml'
    end
  end

  def self.feed_source
    rss = RSS::Parser.parse('http://aws-blog.io/feed.xml', false)
  end

  def self.posting_times
    timings = {
      "facebook" => { 4 => [13, 15, 17], 5 => [13, 15, 17] },
      "linkedin" => { 2 => [7, 10, 17], 3 => [7, 10, 17], 4 => [7, 10, 17] },
      "xing" => { 2 => [7, 10, 17], 3 => [7, 10, 17], 4 => [7, 10, 17] },
      "twitter" => { 3 => [12, 17, 18], 6 => [12, 5, 18], 7 => [12, 5, 18] },
      "pinterest" => { 6 => [20, 23] }
    }
  end

end
