module RandomAdSelector
  extend ActiveSupport::Concern

  class_methods do
    def random_for_event(event, location)
      return nil unless event.present?

      base_scope = where('end_date >= ?', Date.today)

      if event.postal_code.present?
        base_scope.where(zipcode: event.postal_code, location: location, paused: false).order('RANDOM()').first
      else
        base_scope.where(country: event.country, location: location, paused: false).order('RANDOM()').first
      end
    end
  end
end
