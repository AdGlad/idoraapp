require 'aws-sdk'

client = Aws::Rekognition::Client.new(region: 'eu-west-1')
resp = client.create_collection({ collection_id: "ManlySeaEagles", })

