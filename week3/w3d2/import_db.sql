CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id)
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies (
  reply_id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (parent_id) REFERENCES replies (reply_id)
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('John', 'Smith'), ('Timur', 'Meyster'), ('Kirk', 'Min');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('Ruby?', 'What is Ruby?', (SELECT id FROM users WHERE fname = 'John')),
  ('SQL?', 'Why learn SQL?', (SELECT id FROM users WHERE fname = 'Timur')),
  ('Cool?', 'Is Timur cool?', (SELECT id FROM users WHERE fname = 'Kirk')),
  ('life?', 'What is life?', (SELECT id FROM users WHERE fname = 'Kirk'));

INSERT INTO
  replies (question_id, parent_id, user_id, body)
VALUES
  (1, NULL, 3, 'Ruby is a rock.'),
  (1, 1, 2, 'It is language.');

INSERT INTO
  question_followers (question_id, user_id)
VALUES
  (1, 1),
  (2, 1),
  (3, 3),
  (2, 3),
  (2, 2),
  (3, 1);

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (1, 1),
  (1, 2),
  (1, 3),
  (2, 1),
  (2, 2),
  (3, 1);
