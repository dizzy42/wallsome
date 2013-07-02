class MiscellaneousController < ApplicationController
  skip_around_filter :set_resource_site_and_user

  def help
  end
end
