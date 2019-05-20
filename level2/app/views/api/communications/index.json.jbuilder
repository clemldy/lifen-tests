json.communications @communications do |communication|
  json.sent_at communication.sent_at
  json.first_name communication.practitioner.first_name
  json.last_name communication.practitioner.last_name
end
