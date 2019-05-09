module DbTestHelpers

  def get_db_handler()
    db = SQLite3::Database.open './test_db.sqlite3'
  end

  def get_test_db_file()
    './test_db.sqlite3'
  end

  def create_test_db_schema(db)
    drop_tables_if_exist(db)
    db.execute 'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT)'
    db.execute 'CREATE TABLE disallowed_usernames(id INTEGER PRIMARY KEY, invalid_username TEXT)'
  end

  def load_test_db(db)
    disallowed_usernames = test_disallowed_usernames()
    disallowed_usernames.each do |username|
      db.execute "INSERT INTO disallowed_usernames(invalid_username) VALUES ('#{username}')"
    end

    users = test_users()
    users.each do |username|
      db.execute "INSERT INTO users(username) VALUES ('#{username}')"
    end
  end

  def drop_tables_if_exist(db)
    db.execute 'DROP TABLE IF EXISTS users'
    db.execute 'DROP TABLE IF EXISTS disallowed_usernames'
  end

  def drop_test_tables_and_close(db)
    db.execute 'DROP TABLE IF EXISTS users'
    db.execute 'DROP TABLE IF EXISTS disallowed_usernames'
    db.close
  end

  def find_duplicate_usernames(db)
    query = <<-SQL
    SELECT COUNT(username), username
    FROM users
    GROUP BY username
    HAVING COUNT(username) > 1
    SQL
    db.execute query
  end

  def find_disallowed_usernames(db)
    results = []
    test_disallowed_usernames().each do |username|
      user = db.execute "SELECT username FROM users WHERE username='#{username}';"
      results << user if !user.empty?
    end
    results
  end


  def test_disallowed_usernames
    ['grailed', 'privacy', 'settings']
  end

  def test_users
    ['john', 'john', 'grailed', 'bill', 'bill', 'bill1']
  end
end
