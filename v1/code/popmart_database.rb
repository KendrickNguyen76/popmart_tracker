# NEEDS DOCUMENTATION/COMMENTS

# Require Statements
require "sqlite3"

class PopMartDatabaseHandler
    def initialize(database_path)
        @db = SQLite3::Database.new database_path
        create_tables()
    end

    def create_tables
        @db.execute <<-SQL
            CREATE TABLE IF NOT EXISTS popmart_sets (
                brand TEXT,
                series_name TEXT,
                price REAL,
                PRIMARY KEY (brand, series_name)
            ) STRICT;
        SQL
        
        # We'll come back to the figures table later
        """
        @db.execute <<-SQL
            CREATE TABLE IF NOT EXISTS figures (
                figure_name TEXT,
                probability REAL,
                is_collected INTEGER,
                is_secret INTEGER,
                brand TEXT,
                series_name TEXT,
                FOREIGN KEY (brand, series_name) REFERENCES popmart_sets (brand, series_name)
            ) STRICT;
        SQL
        """
    end

    def add_set_to_database(brand, series_name, price)
        @db.execute "INSERT INTO popmart_sets (brand, series_name, price) VALUES (?, ?, ?)", [brand, series_name, price]
    end
        
    def get_set_information(brand, series_name)
        result = @db.execute("SELECT * FROM popmart_sets WHERE brand = ? AND series_name = ?", [brand,series_name])
        if !result.empty?
            return result[0]
        end
    end

    def reset_database_for_testing_only
        @db.execute "DROP TABLE popmart_sets"
    end

    def close_database
        @db.close
    end
end