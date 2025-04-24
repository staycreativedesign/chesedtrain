module Admin
  class AdsController < DashboardsController
    before_action :find_ad, only: %i[edit update destroy]
    def index
      @ads = Ad.all
    end

    def show; end

    def new
      @ad = Ad.new
    end

    def create
      @ad = Ad.new(ad_params)

      if @ad.save
        redirect_to admin_ads_path
        flash[:notice] = 'Ad created'
      else
        render :new
        flash[:notice] = 'Please fix errors'
      end
    end

    def edit; end

    def track
      ad = Ad.find(params[:id])
      ad.increment!(:views)
      head :ok
    end

    def update
      if @ad.update(ad_params)
        redirect_to admin_ads_path
        flash[:notice] = 'Ad updated'
      else
        render :edit
        flash[:notice] = 'Please fix errors'
      end
    end

    def destroy
      @ad.destroy
      redirect_to admin_ads_path
      flash[:notice] = 'Ad destroyed'
    end

    private

    def ad_params
      params.require(:ad).permit(:name, :start_date, :end_date, :country, :zipcode, :views, :clicks, :image, :link, :location, :paused)
    end

    def find_ad
      @ad = Ad.find(params[:id])
    end
  end
end
