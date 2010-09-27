# Sc2Profiles

## scrape starcraft2 battle.net profiles and view them with sinatra

by makevoid and Dakkino


### Installing:

**Database:**

mysql: 
create database sc2profiles_dev and/or edit the configuration in config/env.rb

(optional)
sqlite: if you prefer sqlite over mysql edit config/env.rb and Gemfile and switch the code commented with #sqlite over the one commented with #mysql.



**Dependencies:**

you need ruby 1.9 with bundler gem installed (gem install bundler)
then run:

    bundle install

to install all the dependencies


**Start the server:**

on osx/linux:

    rackup    

or (auto reloading)

    shotgun

on windows:

    ruby config.ru


**Migrate:**

visit **http://localhost:port** in your browser (see the right port in the server log)

you should see a database error, then visit **http://localhost:port/migrate** to migrate the database

**Scrape:**

finally visit **http://localhost:port/scrape** to start scraping the profiles, the table in / will be full of datas 

(note: it's better to remove these two routes in production. They're handy in development, sinatra is so easy that there is almost no need to use things like rake or thor to manage tasks in early prototyping phases,)

also change the style because this is made to match our sc2 team's site colors

note: you can edit public/profiles.txt and add your own profiles

---

**Load irb:**

    irb -r ./config/env.rb

then the env will load with it's dm models and you can do something like:

    Profile.first  #=> first profile 
    Profile.all(race: "zerg") #=> all zerg players
    # ...

notes:  

- works on win/osx/ubuntu
- ruby 1.9 required

