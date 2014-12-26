require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')

    self.results_as_hash = true

    self.type_translation = true

  end
end

class Question

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.get_first_row(<<-SQL, id)
      SELECT
      *
      FROM
      questions
      WHERE
      id = ?
    SQL

    Question.new(data)
  end

  def self.find_by_author(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
    *
    FROM
    questions
    WHERE
    user_id = ?
    SQL

    data.map {|data| Question.new(data) }
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  attr_accessor :id, :title, :body, :author, :user_id

  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def author
    User.find_by_id(@user_id)
  end

  def replies
    Reply.find_by_question_id(id)
  end

  def followers
    QuestionFollower.followers_for_question_id(id)
  end

  def most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def attrs
    { title: title, body: body, user_id: user_id }
  end

  def save
    if @id
      QuestionsDatabase.instance.execute(<<-SQL, attrs.merge({ id: id }))

      UPDATE
        questions
      SET
        title = :title, body = :body, user_id = :user_id
      WHERE
        questions.id = :id
      SQL

    else
      QuestionsDatabase.instance.execute(<<-SQL, attrs)

      INSERT INTO
        questions (title, body, user_id)
      VALUES
        (:title, :body, :user_id)
      SQL

      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end

end

class User
  attr_accessor :id, :fname, :lname
  attr_reader :followed_questions

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.get_first_row(<<-SQL, id)
    SELECT
      *
    FROM
      users
    WHERE
      id = ?
    SQL
    User.new(data)
  end

  def self.find_by_name(fname, lname)
    data = QuestionsDatabase.instance.get_first_row(<<-SQL, fname, lname)
    SELECT
      *
    FROM
      users
    WHERE
      fname = ?
    AND
      lname = ?
    SQL
    User.new(data)
  end

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_author(id)
  end

  def authored_replies
    Reply.find_by_user_id(id)
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(self.id)
  end

  def average_karma
    data = QuestionsDatabase.instance.execute(<<-SQL, @id)
    SELECT
      CAST(COUNT(likes.user_id) AS FLOAT)/COUNT(DISTINCT(questions.id))
    FROM
        (SELECT
        q.id, q.title, q.body, q.user_id
        FROM
        questions q
        WHERE
        q.user_id = ?) questions
        LEFT OUTER JOIN
        question_likes likes
        ON (questions.id = likes.question_id)
    SQL
    data
    # data.map {|datum| Question.new(datum) }
  end

  def attrs
    { id: id, fname: fname, lname: lname }
  end

  def save
    if @id
      QuestionsDatabase.instance.execute(<<-SQL, attrs.merge({ id: id }))

      UPDATE
      users
      SET
      fname = :fname, lname = :lname
      WHERE
      users.id = :id
      SQL

    else
      QuestionsDatabase.instance.execute(<<-SQL, attrs)

      INSERT INTO
      users (fname, lname)
      VALUES
      (:fname, :lname)
      SQL

      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end
end

class QuestionFollower
  attr_accessor :question_id, :user_id

  def self.most_followed_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      a.id, a.title, a.body, a.user_id
    FROM
      question_followers q
      JOIN
      questions a
      ON (a.id = q.question_id)
    GROUP BY
      a.id
    ORDER BY COUNT(q.user_id) DESC LIMIT ?
    SQL
    data.map {|question| Question.new(question)}
  end

  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT DISTINCT
      a.id, a.title, a.body, a.user_id
    FROM
      questions a
      JOIN
      question_followers q
      ON (a.id = q.question_id)
    WHERE
      q.user_id = ?
    SQL
    data.map {|datum| Question.new(datum) }
  end

  def self.followers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT DISTINCT
      u.id, u.fname, u.lname
    FROM
      users u
      JOIN
      question_followers q
      ON (u.id = q.user_id)
    WHERE
      q.question_id = ?
    SQL
    data.map {|datum| User.new(datum) }
  end


  def initialize(options = {})
    @question_id, @user_id = options['question_id'], options['user_id']
  end

end

class Reply
  attr_accessor :reply_id, :question_id, :parent_id, :user_id, :body

  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.get_first_row(<<-SQL, user_id)
    SELECT
      *
    FROM
      replies
    WHERE
      user_id = ?
    SQL
    Reply.new(data)
  end

  def self.find_by_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = ?
    SQL
    data.map {|datum| Reply.new(datum)}
  end

  def self.find_by_reply_id(reply_id)
    data = QuestionsDatabase.instance.get_first_row(<<-SQL, reply_id)
    SELECT
      *
    FROM
      replies
    WHERE
      reply_id = ?
    SQL
    Reply.new(data)
  end


  def initialize(options = {})
    @reply_id = options['reply_id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
  end

  def author
    User.find_by_id(user_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    Reply.find_by_reply_id(parent_id)
  end

  def child_reply
    data = QuestionsDatabase.instance.get_first_row(<<-SQL, reply_id)
    SELECT
      *
    FROM
      replies
    WHERE
      parent_id = ?
    SQL
    Reply.new(data)
  end

  def attrs
    { question_id: question_id, parent_id: parent_id, user_id: user_id, body: body }
  end

  def save
    if @id
      QuestionsDatabase.instance.execute(<<-SQL, attrs.merge({ id: id }))

      UPDATE
      replies
      SET
      question_id = :question_id, parent_id = :parent_id, user_id = :user_id, body = :body
      WHERE
      replies.id = :id
      SQL

    else
      QuestionsDatabase.instance.execute(<<-SQL, attrs)

      INSERT INTO
      replies (question_id, parent_id, user_id, body)
      VALUES
      (:question_id, :parent_id, :user_id, :body)
      SQL

      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end
end

class QuestionLike
  def self.likers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT DISTINCT
      u.id, u.fname, u.lname
    FROM
      users u
    JOIN
      question_likes l
    ON (u.id = l.user_id)
    WHERE
    l.question_id = ?
      SQL

    data.map {|datum| User.new(datum) }
  end

  def self.num_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT DISTINCT
      Count(u.id)
    FROM
    users u
    JOIN
    question_likes l
    ON (u.id = l.user_id)
    WHERE
    l.question_id = ?
    SQL
    data
  end

  def self.liked_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT DISTINCT
      q.id, q.title, q.body, q.user_id
    FROM
      questions q
    JOIN
      question_likes l
      ON (q.id = l.question_id)
    WHERE
      l.user_id = ?
    SQL
    data.map {|datum| Question.new(datum) }
  end

  def self.most_liked_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      q.id, q.title, q.body, q.user_id
    FROM
      questions q
      JOIN
        question_likes l
      ON (q.id = l.question_id)
    GROUP BY
      q.id
    ORDER BY
      COUNT(l.user_id) DESC LIMIT ?
    SQL
    data.map {|datum| Question.new(datum) }
  end

  attr_accessor :question_id, :user_id

  def initialize(options = {})
    @question_id, @user_id = options['question_id'], options['user_id']
  end

  def likers
    QuestionLike.likers_for_question_id(question_id)
  end

  def num_likes
    QuestionLike.num_for_question_id(question_id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(user_id)
  end
end
