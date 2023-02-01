-- DROP TABLES IF EXIST
-- DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS unit;
DROP TABLE IF EXISTS topic;
DROP TABLE IF EXISTS subTopic;
DROP TABLE IF EXISTS learningAim;
DROP TABLE IF EXISTS studentLearningAimProgress;


-- AUTHENTICATION
CREATE TABLE user (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  firstName TEXT,
  secondName TEXT,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL, 
  userType TEXT NOT NULL
);

--STUDENT TABLE
CREATE TABLE student (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  userID INTEGER UNIQUE,
  examYear INTEGER,
  FOREIGN KEY(userID) REFERENCES user(id)
);


-- COURSE TABLE
CREATE TABLE course (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  subject TEXT NOT NULL,
  examBoard TEXT,
  level TEXT
);

-- UNIT TABLE
CREATE TABLE unit (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  unitNumber TEXT,
  unitName TEXT NOT NULL,
  unitDescription TEXT,
  courseID INTEGER,
  FOREIGN KEY(courseID) REFERENCES course(id)

);

-- TOPIC TABLE

CREATE TABLE topic (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  topicNumber REAL,
  topicName TEXT NOT NULL,
  topicDescription TEXT,
  unitID INTEGER,
  FOREIGN KEY(unitID) REFERENCES unit(id)

);

-- SUBTOPIC TABLE

CREATE TABLE subTopic (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  subTopicNumber REAL,
  subTopicName TEXT NOT NULL,
  subTopicDescription TEXT,
  topicID INTEGER,
  FOREIGN KEY(topicID) REFERENCES topic(id)

);

-- SUB TOPIC TABLE
CREATE TABLE learningAim (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  learningAimLetter TEXT,
  learningAimName TEXT NOT NULL,
  learningAimDescription TEXT,
  subTopicID INTEGER,
  FOREIGN KEY(subTopicID) REFERENCES subTopic(id)
);

-- STUDENT LEARNING AIM
CREATE TABLE studentLearningAimProgress (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  progressDate datetime default current_timestamp,
  learningAimID INTEGER,
  studentID INTEGER,
  FOREIGN KEY(studentID) REFERENCES student(id),
  FOREIGN KEY(learningAimID) REFERENCES learningAim(id)
);