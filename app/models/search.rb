class Search < ApplicationRecord

def search_images
  idparams = "ids[" + id1 + id2 + "]"
  tagparams = "tags[" + tag1 + tag2 + tag3 + tag4 + "]"

  if idparams == "ids[]"
   puts "No ids"
   idjoinstring  = ""
   idwherestring = ""
  else
   puts "Ids" + idparams
   idjoinstring  =" inner join image_identities on image_identities.image_id=images.id
                    inner join identities on image_identities.identity_id=identities.id "
   idwherestring = " and  identities.name in (" + 
               "'" + id1 + "'," + "'" + id2 + "') "
  end


  if tagparams == "tags[]"
   puts "No tags"
   tagjoinstring  = ""
   tagwherestring = ""
  else
   puts "Tags" + tagparams
   tagjoinstring  =" inner join image_tags on image_tags.image_id=images.id
                    inner join tags on image_tags.tag_id=tags.id "
   tagwherestring = " and  tags.name in (" + 
               "'" + tag1 + "'," + "'" + tag2 + "'," + 
               "'" + tag3 + "'," + "'" + tag4 + "') "
  end

  wherestring = " where 1=1 " 

  sqlstring = idjoinstring  + tagjoinstring  + wherestring + idwherestring + tagwherestring
  puts sqlstring 

  images=Image.joins(sqlstring).uniq

  return images

end

end
