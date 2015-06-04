require 'rss'

class FeedsController < ApplicationController

  def facebook
    respond_to do |wants|
      wants.rss { render :text => Feed.get_feed("facebook").to_s }
    end
  end

  def linkedin
    respond_to do |wants|
      wants.rss { render :text => Feed.get_feed("linkedin").to_s }
    end
  end

  def xing
    respond_to do |wants|
      wants.rss { render :text => Feed.get_feed("xing").to_s }
    end
  end

  def twitter
    respond_to do |wants|
      wants.rss { render :text => Feed.get_feed("twitter").to_s }
    end
  end

  def pinterest
    respond_to do |wants|
      wants.rss { render :text => Feed.get_feed("pinterest").to_s }
    end
  end

end
