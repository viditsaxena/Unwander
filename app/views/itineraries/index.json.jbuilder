json.array!(@itineraries) do |itinerary|
  json.extract! itinerary, :id, :description, :image_url
  json.url itinerary_url(itinerary, format: :json)
end
