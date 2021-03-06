require_relative '../db'
require_relative './db_test_helpers'
require_relative 'spec_helper.rb'

include DbTestHelpers

describe Db do
  before(:each) do
    test_db_file = get_test_db_file()
    @test_db = get_db_handler()
    create_test_db_schema(@test_db)
    load_test_db(@test_db)
    @db_interface = Db.new(test_db_file)
  end

  after(:each) do
    drop_test_tables_and_close(@test_db)
  end

  it "finds users with disallowed names" do
    disallowed_users = @db_interface.get_users_with_disallowed_usernames()

    expect(disallowed_users[0][:username]).to eq 'grailed'
  end

 it 'pretty prints users with disallowed names' do
   expect {@db_interface.pretty_print_users_with_disallowed_names()}.to output("grailed with id 3\n").to_stdout
 end

 it 'resolves username collisions' do
   @db_interface.resolve_username_collisions(dry_run=false)
   duplicate_users = find_duplicate_usernames(@test_db)

   expect(duplicate_users.length).to eq 0
 end

 it 'resolves disallowed users collisions' do
   @db_interface.resolve_disallowed_username_collisions(dry_run=false)
   disallowed_users = find_disallowed_usernames(@test_db)

   expect(disallowed_users.length).to eq 0
 end
end
