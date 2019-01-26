class Search < ApplicationRecord

def search_images
  idparams = "ids[" + id1 + id2 + "]"
  tagparams = "tags[" + tag1 + tag2 + tag3 + tag4 + "]"
  tagjoinstring  = " "
  tagwherestring = " "
  tagjoinstring1  = " "
  tagwherestring1 = " "
  tagjoinstring2  = " "
  tagwherestring2 = " "
  tagjoinstring3  = " "
  tagwherestring3 = " "
  tagjoinstring4  = " "
  tagwherestring4 = " "
  idjoinstring  = " "
  idwherestring = " "
  idjoinstring1  = " "
  idwherestring1 = " "
  idjoinstring2  = " "
  idwherestring2 = " "
  puts "#############"
  puts "Search_images"
  puts idparams + tagparams 
  puts "user_id " + user_id.to_s
  #@user=User.find(self.user_id)
  #@current_user ||= User.find(session[:user_id])
  #puts "current_user.id" + self.user_id
  puts "user_id" + self.user_id.to_s
  puts "#############"

  if idparams == "ids[]"
   puts "No ids"
  else
   puts "Ids" + idparams
   if id1 != ""
     idjoinstring1  =" inner join image_identities as ii1 on ii1.image_id=images.id
                       inner join identities id1 on ii1.identity_id=id1.id  "
     idwherestring1 = " and  id1.user_id = 1 and  id1.name = "  + "'" + id1 + "'" 
   end
   if id2 != ""
     idjoinstring2  =" inner join image_identities as ii2 on ii2.image_id=images.id
                       inner join identities id2 on ii2.identity_id=id2.id  "
     idwherestring2 = " and  id2.user_id = 1 and  id2.name = "  + "'" + id2 + "'" 
   end 

  idjoinstring  = [idjoinstring1 ,  idjoinstring2  ].join
  idwherestring = [idwherestring1  , idwherestring2 ].join

  puts "idjoinstring[" +  idjoinstring + "]"
  puts "idwherestring[" +  idwherestring + "]"


  end

  if tagparams == "tags[]"
   puts "No tags"
  else
   puts "Tags" + tagparams
   if tag1 != ""
   tagjoinstring1  =" inner join image_tags as it1 on it1.image_id=images.id
                      inner join tags as t1 on it1.tag_id=t1.id "
   tagwherestring1 = " and  t1.name = " + "'" + tag1 + "'"
   end
   if tag2 != ""
   tagjoinstring2  =" inner join image_tags as it2 on it2.image_id=images.id
                      inner join tags as t2 on it2.tag_id=t2.id "
   tagwherestring2 = " and  t2.name = " + "'" + tag2 + "'"
   end
   if tag3 != ""
   tagjoinstring3  =" inner join image_tags as it3 on it3.image_id=images.id
                      inner join tags as t3 on it3.tag_id=t3.id "
   tagwherestring3 = " and  t3.name = " + "'" + tag1 + "'"
   end
   if tag4 != ""
   tagjoinstring4  =" inner join image_tags as it4 on it4.image_id=images.id
                      inner join tags as t4 on it4.tag_id=t4.id "
   tagwherestring4 = " and  t4.name = " + "'" + tag4 + "'"
   end

  puts "tagwherestring [" +  tagwherestring + "]"
  end

  tagjoinstring  = [tagjoinstring1 ,  tagjoinstring2 ,  tagjoinstring3   ,  tagjoinstring4  ].join
  tagwherestring = [tagwherestring1  , tagwherestring2, tagwherestring3  , tagwherestring4 ].join

  puts "tagjoinstring[" +  tagjoinstring + "]"
  puts "tagwherestring[" +  tagwherestring + "]"
  wherestring = " where images.user_id=1 " 

  sqlstring = idjoinstring + tagjoinstring  + wherestring + idwherestring + tagwherestring
  puts sqlstring 

  images=Image.joins(sqlstring).uniq

  return images

end

end
