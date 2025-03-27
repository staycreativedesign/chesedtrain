class AdsController < ApplicationController
  def track
    ad = Ad.find(params[:id])
    ad.increment!(:clicks)
    head :ok
  end
end
