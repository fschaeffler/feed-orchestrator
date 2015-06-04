require 'rss'

class Feed

  def self.get_feed(network)
    time = Time.now
    source = feed_source
    feed = source.clone
 
    if include_post?(network, time) && source.channel.items.length > 0
      first_feed_item = source.channel.items[0]
      first_feed_item.link = first_feed_item.link + "?utm_source=" + network + "&utm_medium=feed_rchestrator&utm_content=" + time.strftime("%Y-%m-%d_%H")  + "&utm_campaign=" + time.wday.to_s + "-" + time.hour.to_s
      first_feed_item.comments = "Re-Post: " + DateTime.parse(time.strftime("%Y-%m-%d %H")).rfc2822

      feed.items.clear
      feed.items << first_feed_item
    end

    feed
  end

  private

  def self.include_post?(network, time)
    timings = posting_times[network]

    if timings.has_key?(time.wday)
      if timings[time.wday].include?(time.hour)
        return true
      end
    end

    false
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
