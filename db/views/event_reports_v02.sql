SELECT
  events.name AS "event_name",
  events.type AS "event_type",
  users.first_name || ' ' || users.last_name AS "owner",
  users.email_address as "email",
  users.area_code || ' ' || users.phone_number AS "contact_number",
  events.start_date AS "start_date",
  events.end_date AS "end_date",
  events.recipent_email AS "recipient_email",
  events.recipent_name AS "recipient_name",
  events.country,
  events.postal_code,
  events.state,
  events.created_at,
  COUNT(volunteer_events.id) AS "volunteer_count"
FROM events
JOIN users ON events.owner_id = users.id
LEFT JOIN volunteer_events ON events.id = volunteer_events.event_id
WHERE users.guest = FALSE
GROUP BY events.id, users.id
