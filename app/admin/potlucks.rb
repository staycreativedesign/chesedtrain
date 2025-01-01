ActiveAdmin.register Potluck do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :start_date, :end_date, :recipent_email, :recipent_name, :address1, :address2, :city, :state,
                :adults, :kids, :allergies, :preferred_time, :dietary_restrictions, :special_message, :owner_id, :type, :least, :shabbat_instructions, :fav_rest, :date_range, :step, :country, :postal_code
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :start_date, :end_date, :recipent_email, :recipent_name, :address1, :address2, :city, :state, :adults, :kids, :allergies, :preferred_time, :dietary_restrictions, :special_message, :owner_id, :type, :least, :shabbat_instructions, :fav_rest, :date_range, :step, :country, :postal_code]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
