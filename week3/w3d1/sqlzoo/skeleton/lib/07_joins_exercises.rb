# == Schema Information
#
# Table name: actor
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movie
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director    :integer
#
# Table name: casting
#
#  movieid     :integer      not null, primary key
#  actorid     :integer      not null, primary key
#  ord         :integer

require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)

  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
  SELECT
    m.title
  FROM
    actor a
    JOIN
    casting c
    ON (a.id = c.actorid)
    JOIN movie m
    ON (c.movieid = m.id)
  WHERE
    a.name = 'Harrison Ford'
  SQL
end

def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the star
  # role. [Note: the ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role]
  execute(<<-SQL)
  SELECT
    m.title
  FROM
    actor a
    JOIN
    casting c
      ON (a.id = c.actorid)
      JOIN movie m
        ON (c.movieid = m.id)
  WHERE
  a.name = 'Harrison Ford' AND ord != 1
  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
  SELECT
    m.title, a.name
  FROM
    actor a
    JOIN casting c
      ON (a.id = c.actorid)
      JOIN movie m
      ON (c.movieid = m.id)
  WHERE
    m.yr = 1962 AND c.ord = 1
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
  SELECT
    m.yr, COUNT(m.title)
  FROM
    actor a
    JOIN casting c
      ON (a.id = c.actorid)
      JOIN movie m
      ON (c.movieid = m.id)
  WHERE
  a.name = 'John Travolta'
  GROUP BY
    yr
  HAVING COUNT(m.title) >= 2

  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
  SELECT
    mm.title, aa.name
  FROM
    actor aa
      JOIN casting cc
      ON (aa.id = cc.actorid)
      JOIN movie mm
      ON (cc.movieid = mm.id)
  WHERE
    mm.title IN (SELECT
                m.title
              FROM
                actor a
                JOIN casting c
                ON (a.id = c.actorid)
                  JOIN movie m
                  ON (c.movieid = m.id)
              WHERE
              a.name = 'Julie Andrews'
            )
    AND
      (ord = 1)
  SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL)
  SELECT
    a.name
  FROM
    actor a
      JOIN casting c
      ON (a.id = c.actorid)
        JOIN movie m
        ON (c.movieid = m.id)
  WHERE
    (c.ord = 1)
  GROUP BY
    a.name
  HAVING
    COUNT(*) >= 15
  ORDER BY
    a.name
  SQL
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast (descending), then by title (ascending).
  execute(<<-SQL)
  SELECT
    m.title, COUNT(c.actorid)
  FROM
    casting c
    JOIN movie m
    ON (c.movieid = m.id)
  WHERE
    m.yr = 1978
  GROUP BY
    m.title
  ORDER BY
    COUNT(*) DESC, m.title ASC

  SQL
end

def colleagues_of_garfunkel
  # List all the people who have worked with 'Art Garfunkel'.
  execute(<<-SQL)
    SELECT
      m2.name
    FROM
        (SELECT
          m.id
          FROM
          movie m
          JOIN casting c
          ON (m.id = c.movieid)
          JOIN actor a
          ON (c.actorid = a.id)
          WHERE
          a.name = 'Art Garfunkel') a1
          JOIN
          (SELECT
            aa.name , ccc.movieid
           FROM
            actor aa
            JOIN casting ccc
            ON (aa.id = ccc.actorid)
            WHERE
            aa.name != 'Art Garfunkel') m2
          ON a1.id = m2.movieid

  SQL
end
