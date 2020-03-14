class MicropostsController < ApplicationController
  before_action :only_logged_in, only:[:create, :destroy]

  def create;  end
  def destroy;  end

end
