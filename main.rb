require_relative 'db'
db = db.new

while !db.quit
  command = gets.chomp.downcase
  case command
  when "resolve disallowed username collisions"
    puts "Do you want this to be a dry run? Enter Y/N"
    response = gets.chomp
    dry_run = response.downcase.includes? 'y' ? true : false
    db.resolve_disallowed_username_collisions(dry_run)
  when "resolve username collisions"
    puts "Do you want this to be a dry run? Enter Y/N"
    response = gets.chomp
    dry_run = response.downcase.includes? 'y' ? true : false
    db.resolve_username_collisions(dry_run)
  when "pretty print users with disallowed usernames"
    db.pretty_print_users_with_disallowed_names(dry_run)
  when "quit"
    db.quit()
  else
    puts "That is not a recognized command"
  end
end
