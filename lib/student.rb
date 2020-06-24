class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_stu = Student.new
    new_stu.id = row[0]
    new_stu.name = row[1]
    new_stu.grade = row[2]
    new_stu
    # create a new Student object given a row from the database
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL
    all = DB[:conn].execute(sql)
    all.map do |row|
      self.new_from_db(row)
    end
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students WHERE
    name = ?
    LIMIT 1
    SQL
    row = DB[:conn].execute(sql, name).first
    obj = Student.new_from_db(row)
    # find the student in the database given a name
    # return a new instance of the Student class
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students where
    grade = 9
    SQL
    rows = DB[:conn].execute(sql)
    # rows.map do |row|
    #   self.new_from_db(row)
    # end
  end

def self.students_below_12th_grade
  sql = <<-SQL
  SELECT * FROM students WHERE
  grade < 12
  SQL
  rows = DB[:conn].execute(sql)
  rows.map do |row|
    self.new_from_db(row)
  end
end

def self.first_X_students_in_grade_10(num)
  sql = <<-SQL
  SELECT * FROM students WHERE
  grade = 10
  LIMIT ?
  SQL
  rows = DB[:conn].execute(sql, num)
  rows.map do |row|
    self.new_from_db(row)
  end
end

def self.first_student_in_grade_10
  self.first_X_students_in_grade_10(1).first
end

def self.all_students_in_grade_X(num)
  sql = <<-SQL
  SELECT * FROM students where
  grade = ?
  SQL
  rows = DB[:conn].execute(sql, num)
  rows.map do |row|
    self.new_from_db(row)
  end
end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
