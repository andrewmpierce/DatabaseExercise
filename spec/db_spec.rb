require_relative '../db'
require_relative './db_test_helpers'

include DbTestHelpers

describe Db do
  context "Set up the test Db" do
    test_db_file = get_test_db_file()

    it "finds users with disallowed names" do
      test_db = get_db_handler()
      create_test_db_schema(test_db)
      load_test_db(test_db)
      db_interface = Db.new(test_db_file)
      disallowed_users = db_interface.get_users_with_disallowed_usernames()
      expect(disallowed_users[0][:username]).to eq 'grailed'
      drop_test_tables_and_close(test_db)
    end

   it 'pretty prints users with disallowed names' do
     test_db = get_db_handler()
     create_test_db_schema(test_db)
     load_test_db(test_db)
     db_interface = Db.new(test_db_file)
     expect {db_interface.pretty_print_users_with_disallowed_names()}.to output("grailed with id 3\n").to_stdout
     drop_test_tables_and_close(test_db)
   end

   it 'resolves username collisions' do
     test_db = get_db_handler()
     create_test_db_schema(test_db)
     load_test_db(test_db)
     db_interface = Db.new(test_db_file)
     db_interface.resolve_username_collisions(dry_run=false)
     duplicate_users = find_duplicate_usernames(test_db)
     expect(duplicate_users.length).to eq 0
     drop_test_tables_and_close(test_db)
   end
 end
end
