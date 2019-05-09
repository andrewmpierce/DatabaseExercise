require 'sqlite3'

class Db
  attr_reader :request_to_exit

  def initialize(db_file)
    @db = get_db_handler(db_file)
    @request_to_exit = false
  end

  def resolve_username_collisions(dry_run=true)
    duplicate_users = find_duplicate_usernames()
    duplicate_users_hash_array = convert_to_hashes(duplicate_users)
    duplicate_users_hash_array.each do |user|
      users_to_change = @db.execute "SELECT * FROM users WHERE username='#{user[:username]}';"
      users_to_change = convert_to_hashes(users_to_change[1.. -1])
      update_users(users_to_change, dry_run)
    end
  end

  def resolve_disallowed_username_collisions(dry_run=true)
    users = get_users_with_disallowed_usernames()
    update_users(users, dry_run)
  end

  def pretty_print_users_with_disallowed_names()
    users = get_users_with_disallowed_usernames()
    users.each do |user|
      puts "#{user[:username]} with id #{user[:id]}"
    end
  end

  def get_users_with_disallowed_usernames()
    disallowed_usernames = get_disallowed_usernames()
    invalid_users = []
    disallowed_usernames.each do |username|
      invalid_user = @db.execute "SELECT id, username FROM users WHERE username='#{username[:username]}';"
      invalid_user = convert_to_hashes(invalid_user)
      invalid_users << invalid_user
    end
    invalid_users.flatten
  end

  def quit
    @request_to_exit = true
    @db.close if @db
    puts 'Bye!'
  end

  private def get_db_handler(db_file)
    SQLite3::Database.open db_file
  end

  private def get_disallowed_usernames
    disallowed_usernames = @db.execute "SELECT id, invalid_username FROM disallowed_usernames;"
    convert_to_hashes(disallowed_usernames)
  end

  private def find_duplicate_usernames
    query = <<-SQL
    SELECT COUNT(username), username
    FROM users
    GROUP BY username
    HAVING COUNT(username) > 1
    SQL
    @db.execute query
  end

  private def update_users(users_to_change, dry_run)
    counter = 1
    usernames = []
    users_to_change.each do |user_to_change|
      counter = 1 if user_to_change[:username] != usernames[-1]
      usernames << user_to_change[:username]
      potential_new_username = user_to_change[:username] + counter.to_s
      new_username = get_new_username(potential_new_username)
      counter = (new_username[-1].to_i) + 1
      if dry_run
        puts "#{user_to_change[:username]} with id #{user_to_change[:id]} will become #{new_username}"
      else
        @db.execute "UPDATE users SET username='#{new_username}' WHERE id=#{user_to_change[:id]};"
        puts "#{user_to_change[:username]} with id #{user_to_change[:id]} became #{new_username}"
      end
    end
  end

  private def get_new_username(username)
    while existing_user?(username)
      num = (username[-1].to_i) + 1
      username[-1] = num.to_s
    end
    username
  end

  private def existing_user?(username)
    existing_users = @db.execute "SELECT * FROM users WHERE username='#{username}';"
    existing_users.empty? ? false : true
  end

  private def convert_to_hashes(array_of_arrays)
    return_array = []
    array_of_arrays.each do |array|
      return_array << {id: array[0], username: array[1]}
    end
    return_array
  end
end
