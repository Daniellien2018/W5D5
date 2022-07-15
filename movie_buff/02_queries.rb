def eighties_b_movies
  # List all the movies from 1980-1989 with scores falling between 3 and 5
  # (inclusive). Show the id, title, year, and score.
  #show id, title, yr, score, where yr between 1980, 1989, AND score beteween 3,5
  Movie
  .select(:id, :title, :yr, :score)
  .where(yr: 1980..1989)
  .where(score: 3..5)
end

def bad_years
  # List the years in which no movie with a rating above 8 was released.
  Movie
  .select(:yr)
  # .where.not('score > (?)', 8)
  .group(:yr)
  .having('MAX(score) < 8')
  .pluck(:yr)
end

def cast_list(title)
  # List all the actors for a particular movie, given the title.
  # Sort the results by starring order (ord). Show the actor id and name.

  #return actor id and namelist actors from movie. join on castings (from movies) and sort ORD asc
  Actor
  .select(:id, :name)
  .joins(:movies)
  .where("movies.title IN (?)", title)
  .order("castings.ord ASC")

  # .group("movies.id")
  # .having("movies.title IN (?)", title)
  # .select(:id, :name)
  # .joins(:movie)
  # .joins(:castings)


end

def vanity_projects
  # List the title of all movies in which the director also appeared as the
  # starring actor. Show the movie id, title, and director's name.

  # Note: Directors appear in the 'actors' table.
  #
  Movie
  .select(:id, :title, "actors.name")
  .joins(:actors)
  .where("movies.director_id = actors.id")
  .where("castings.ord = 1")

  
end

def most_supportive
  # Find the two actors with the largest number of non-starring roles.
  # Show each actor's id, name, and number of supporting roles.

  #order(count(ord > 1 ))
  #MAX(score) ==> MIN(ord) > 1
  #limit 2
  
  #count ord != 1
  #order by count
  #limit 2 

  Actor
  .select(:id, :name, 'COUNT(castings.ord) AS roles ')
  .joins(:castings)
  .where.not('castings.ord = 1')
  .group(:id)
  .order("count(castings.ord) DESC")
  .limit(2)
end