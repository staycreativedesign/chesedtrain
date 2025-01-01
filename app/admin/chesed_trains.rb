ActiveAdmin.register ChesedTrain do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :start_date, :end_date, :recipent_email, :recipent_name, :address1, :address2, :city, :state,
                :adults, :kids, :allergies, :preferred_time, :dietary_restrictions, :special_message, :owner_id, :type, :least, :shabbat_instructions, :fav_rest, :date_range, :step, :country, :postal_code, event_dates_attributes: %i[id bringing date_month date_number date_weekday full_date special_note chesed_train_id volunteer_id]
  show do
    attributes_table do
      row :name
      row :start_date
      row :end_date
      row :prefererred_time
      row :recipent_name
      row :recipent_email
      row :kids
      row :allergies
      row :dietary_restrictions
      row :shabbat_instructions
    end
    panel 'Volunteers' do
      table_for chesed_train.volunteers do
        column :id
        column :bringing
        column :full_date
        column :special_note
        column :created_at
      end
    end
  end
end
