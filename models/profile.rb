class Profile
  
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, length: 150
  property :url, String, length: 255
  property :ladder_one, Integer
  property :ladder_two, Integer
  property :ladder_three, Integer
  property :ladder_four, Integer
  property :one_league, Integer
  property :two_league, Integer
  property :three_league, Integer
  property :four_league, Integer
  property :one_rank, Integer
  property :one_division, String, length: 150
  property :two_rank, Integer
  property :three_rank, Integer
  property :four_rank, Integer
  property :one_pts, Integer
  property :one_playeds, Integer
  property :one_wins, Integer
  property :two_pts, Integer
  property :two_playeds, Integer
  property :two_wins, Integer
  property :three_pts, Integer
  property :three_playeds, Integer
  property :three_wins, Integer
  property :four_pts, Integer
  property :four_playeds, Integer
  property :four_wins, Integer
  
  default_scope(:default).update(:order => [:one_league.asc, :one_pts.desc])
  
end