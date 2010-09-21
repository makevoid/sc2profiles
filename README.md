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

    bundle install

edit public/profiles.txt and add your profiles


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

(note: it's better to remove these two route in production, but they're handy in development, sinatra is so easy that's almost no need to use things like rake or thor to manage tasks)

also change the style because this is made to match our team's site colors

---

notes:  

- works on win/osx/ubuntu
- ruby 1.9 required

