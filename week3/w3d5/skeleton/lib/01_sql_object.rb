require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    columns = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        "#{self.table_name}"
    SQL
    columns = columns.first.map {|item| item.to_sym}
  end

  def self.finalize!
    columns = self.columns

    columns.each do |column|

      define_method(column.to_s) do
        attributes[column]
      end

      define_method("#{column}=") do |argument|
        attributes[column] = argument
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.to_s.downcase.tableize
  end

  def self.all
    columns = self.columns.map {|c| c.to_s}

    results = DBConnection.execute(<<-SQL)
    SELECT
      *
    FROM
      "#{self.table_name}"
    SQL
    self.parse_all(results)
  end

  def self.parse_all(results)
    answer = []

    results.each do |row|
      answer << self.new(row)
    end
    answer
  end

  def self.find(id)
    record = DBConnection.execute(<<-SQL, id)
    SELECT
      *
    FROM
      #{self.table_name}
    WHERE
      id = ?
    SQL

    self.parse_all(record).first
  end

  def initialize(params = {})
    columns = self.class.columns

    params.each do |attr_name, value|
      unless columns.include?(attr_name.to_sym)
        raise ArgumentError.new "unknown attribute '#{attr_name}'"
      end
      self.send("#{attr_name.to_sym}=", value)
    end

  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    columns = self.class.columns
    ans = []
    columns.map do |col|
      ans << self.send("#{col}")
    end
    ans
  end

  def insert
    col_names = attributes.keys.join(', ')
    question_marks = (["?"] * (attributes.count)).join(", ")

    DBConnection.execute(<<-SQL, *attribute_values.drop(1))
    INSERT INTO
      #{self.class.table_name} (#{col_names})
    VAlUES
      (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    col_names = attributes.keys.drop(1)

    set_line = []
    col_names.map do |key|
        set_line << "#{key} = ?"
    end

    set_line = set_line.join(", ")

    DBConnection.execute(<<-SQL, *attribute_values.drop(1))
    UPDATE
     #{self.class.table_name}
    SET
      #{set_line}
    WHERE
      id = #{self.id}
    SQL
  end

  def save
    if id.nil?
      insert
    else
      update
    end
  end
end
