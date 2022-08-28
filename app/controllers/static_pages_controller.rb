class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy(current_user.feed, page: params[:page],
items: Settings.pagy.pagy_size)
  end

  def help; end

  def contact; end
end
