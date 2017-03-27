require_relative("../db/sql_runner")
require('pry')

class Film

  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i
    @title = options['title']
    @price = options['price'].to_i
  end

  def save()
    sql = "INSERT INTO films (title, price)
    VALUES ('#{@title}', #{@price}) RETURNING *"
    @id = SqlRunner.run(sql).first()['id'].to_i
  end

  def update()
    sql = "UPDATE films
      SET (title, price) = ('#{@title}', #{@price})
      WHERE id = #{@id}"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM films WHERE id = #{@id}"
    SqlRunner.run(sql)
  end

  def customers()
    sql = "SELECT customers.* FROM customers INNER JOIN tickets ON customers.id = tickets.customer_id WHERE film_id = #{@id}"
    result = SqlRunner.run(sql)
    return result.map{|customer| Customer.new(customer)}
  end

  def price()
    sql = "SELECT films.price FROM films WHERE id = #{@id}"
    film_price = SqlRunner.run(sql).first() 
    return film_price['price'].to_i
    binding.pry
  end

  def self.all()
    sql = "SELECT * FROM films"
    result = SqlRunner.run(sql)
    films = result.map{|film| Film.new(film)}
    return films
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM films WHERE id = #{id}"
    result = SqlRunner.run(sql)
    return result.map{|film| Film.new(film)}.first()
  end

end