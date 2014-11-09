class Scraper
  require 'mechanize'

  # todo: screencast how to build a scraper ... hmm not like this :D

  # service spec:
  #
  #   profile: http://eu.battle.net/sc2/en/profile/536792/1/KiM/
  #
  #   2v2: http://eu.battle.net/sc2/en/profile/536792/1/KiM/ladder/31121#current-rank
  #   3v3: http://eu.battle.net/sc2/en/profile/536792/1/KiM/ladder/33118#current-rank
  #

  BASE_URL = "http://eu.battle.net"

  def self.scrape
    Profile.all.map{ |p| p.destroy } if defined?(Profile)
    path = File.expand_path "../../", __FILE__
    profile_urls = File.read(path+"/public/profiles.txt").split("\n").map{ |n| n.strip }
    #p profile_urls
    agent = Mechanize.new
    agent.user_agent = "Mac Safari"

    profile_urls[0..1].map do |p_url|
      page = agent.get(p_url)

      name = page.search("h2").first.inner_text#.match(/(\w+)#/)
      ranks = page.body.scan(/icons\/league\/(\w+)-medium/)
      totals = page.search(".totals").map{|n| n.inner_text }.map{ |n| n.to_i }


      profile = { name: name, url: p_url, one_league: leagueize(ranks[0]), two_league: leagueize(ranks[1]), three_league: leagueize(ranks[2]), four_league: leagueize(ranks[3]) }

      p profile

      race = page.links.select{ |l| l.href == "ladder/" }.last.text.strip
      profile["race_one"] = race.downcase


      %w{one two three four}.each_with_index do |type, i|
        #profile["#{type}_pts"] = totals[0+i*2]
        profile["#{type}_wins"] = totals[0+i*2]
        profile["#{type}_playeds"] = totals[1+i*2]
      end

      ladders = page.body.scan(/#{base_url(p_url)}ladder\/(\d+)/).map{|l| l.first.to_i}
      %w{one two three four}.each_with_index do |type, i|
        profile["ladder_#{type}"] = ladders[i]

        page = agent.get(ladder_url(p_url, i))
        division = page.search("h3").inner_html
        division_ = division.scan(/\t(.+)\s*<span>\/<\/span>/).last
        profile["#{type}_division"] = division_.first.gsub(/Division /, "").strip unless division_.nil?
        nodes = page.search("*[href='#{base_url(p_url)}']")
        #p base_url(p_url)
        #p nodes.map{ |n| n.inner_html }
        #File.open("/tmp/testpage.html", "w"){ |f| f.write(page.body) }
        #{}`open /tmp/testpage.html`
        #puts base_url(p_url)


        node = nodes[3]
        unless node.nil?
          par = node.parent
          par2 = par.parent.inner_html
          points = par2.scan(/<td class=\"align\-center\">(\d+)<\/td>/).first.first
          rank = par2.match(/40px\">(\d+)(rd|th|nd|st)<\/td>/)[1]
          rank = rank.to_i
          points = points.to_i
          profile["#{type}_pts"] = points
          profile["#{type}_rank"] = rank
        else
          puts "node e' vuoto! > #{name}"
        end
        #        [0].parent.parent.inner_text.inspect
      end



     # "/sc2/it/profile/235029/1/makevoid/ladder/10050#current-rank"


      if defined?(Profile)
        raise profile.inspect
        p = Profile.new(profile)
        puts "scraped: #{name}"
        p.save
      end
    end
    Stats.first.update(updated_at: Time.now)
  end

  def self.ladder_url(url, ladder)
    "#{url}ladder/#{ladder}"
  end

  def self.base_url(url)
    url.gsub(BASE_URL, '')
  end

  def self.leagueize(league)
    puts league
    return false if league.nil?
    case league[0]
    when "master"     then 1
    when "diamond"    then 2
    when "platinum"   then 3
    when "gold"       then 4
    when "silver"     then 5
    when "bronze"     then 6
    when "none"       then -1
    else
      puts "league?: #{league}"
    end
  end
end

#Scraper.scrape