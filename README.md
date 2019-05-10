# Usage Instructions:

There are two major ways to use this database interface. Either run the command
`ruby main.rb` from the root of the directory to open a CLI, or open an irb session
and include the `db.rb` file in the root of the directory.

## 1) Using the CLI

Run `ruby main.rb` from the root of the directory. The CLI is coded to automatically
open the `grailed-exercise.sqlite3` database in the root of the directory. It will
then accept 4 commands.

`Resolve disallowed username collisions` will prompt the user if they want to
proceed as a dry run or not. A dry run will only print the
lines that will be affected, and will not update the database. The user may respond
with `yes/no` or `y/n`

`Resolve username collisions` will resolve any users with duplicate usernames.
It will also prompt the user if they would like to proceed with a dry run.

`Pretty print users with disallowed usernames` will not make any database changes
and will print all users with disallowed usernames in a human readable format.

`quit` will exit the CLI and close the database connection.

## 2) Using the Db class in an IRB session

Open an irb session in the root directory of the project. The Db class is defaulted to use `grailed-exercise.sqlite3`,
but any sqlite3 file with the relevant tables could be used. Simply pass in the file you'd prefer to use if that is 
the case. 

```
$ irb
irb(main):001:0> require_relative 'db'
=> true
irb(main):002:0> db = Db.new
 ```

 The user may then execute the same actions as the CLI.
 
 `db.pretty_print_users_with_disallowed_names`

 `db.resolve_username_collisions(dry_run=true)`

 `db.resolve_disallowed_username_collisions(dry_run=true)`

 The `dry_run` argument is defaulted to `true` for both `resolve_username_collisions`
 and `resolve_disallowed_username_collisions`. To update the database, change the
 `dry_run` argument to `false`. 


# Implementation Language

I chose Ruby to write this sample in. I've been using Ruby for a year and a half. 
