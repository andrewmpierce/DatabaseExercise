require_relative '../db'
require_relative './db_helpers'

include DbHelpers

describe Db do
  context "Set up the test Db" do
    db = create_test_db_schema()
    #load_test_db(db)
    #drop_test_tables_and_close(db)

    it "load test data" do
      load_test_db(db)

    end

 end
end
