module Admin
  class ReportsController < ApplicationController
    def users_report
      @users = UserReports.all

      respond_to do |format|
        format.xlsx do
          response.headers['Content-Disposition'] = 'attachment; filename="users_report.xlsx"'
        end
      end
    end

    def ads_report
      @ads = AdReports.all

      respond_to do |format|
        format.xlsx do
          response.headers['Content-Disposition'] = 'attachment; filename="ads_report.xlsx"'
        end
      end
    end

    def events_report
      @events = EventReports.all

      respond_to do |format|
        format.xlsx do
          response.headers['Content-Disposition'] = 'attachment; filename="events_report.xlsx"'
        end
      end
    end

    def potluck_events_report
      @events = EventReports.where(event_type: 'Potluck')

      respond_to do |format|
        format.xlsx do
          response.headers['Content-Disposition'] = 'attachment; filename="events_report.xlsx"'
        end
      end
    end

    def chesed_events_report
      @events = EventReports.where(event_type: 'ChesedTrain')

      respond_to do |format|
        format.xlsx do
          response.headers['Content-Disposition'] = 'attachment; filename="events_report.xlsx"'
        end
      end
    end
  end
end
