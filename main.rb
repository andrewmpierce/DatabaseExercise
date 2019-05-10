require_relative 'db'
db = Db.new

while !db.request_to_exit
  command = gets.chomp
  case command.downcase
  when "resolve disallowed username collisions"
    puts "Do you want this to be a dry run? Enter Y/N"
    response = gets.chomp
    dry_run = response.downcase.include? 'y'
    db.resolve_disallowed_username_collisions(dry_run)
  when "resolve username collisions"
    puts "Do you want this to be a dry run? Enter Y/N"
    response = gets.chomp
    dry_run = response.downcase.include? 'y'
    db.resolve_username_collisions(dry_run)
  when "pretty print users with disallowed usernames"
    db.pretty_print_users_with_disallowed_names()
  when "quit"
    db.quit()
  else
    puts "That is not a recognized command"
  end
end
