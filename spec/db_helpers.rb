module DbHelpers
  def create_test_db_schema
    db = SQLite3::Database.new './test_db.sqlite3'
    db.execute 'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT)'
    db.execute 'CREATE TABLE disallowed_usernames(id INTEGER PRIMARY KEY, invalid_username TEXT)'
    db
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

  def drop_test_tables_and_close(db)
    db.execute 'DROP TABLE users'
    db.execute 'DROP TABLE disallowed_usernames'
    db.close
  end



  def test_disallowed_usernames
    ['grailed', 'privacy', 'settings']
  end

  def test_users
    ['john' 'john', 'grailed', 'bill', 'bill', 'bill1']
  end
end
