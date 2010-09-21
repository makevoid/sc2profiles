class Stats
  
  include DataMapper::Resource
  
  property :id, Serial
  property :updated_at, DateTime
 
end