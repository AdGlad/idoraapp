require 'aws-sdk'

client = Aws::Rekognition::Client.new(region: 'eu-west-1')

#resp = client.create_collection({ collection_id: "ManlySeaEagles", })
resp = client.list_collections({ })
puts resp.to_h
resp.collection_ids.each do |collection|
  puts collection
  #resp = client.delete_collection({ collection_id: collection })
  #puts resp.to_h
  #puts "#{label.name}-#{label.confidence.to_i}" 
end 
