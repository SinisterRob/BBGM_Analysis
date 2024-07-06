# Setup the connection to the DuckDB database.
con <- dbConnect(duckdb::duckdb(), "../clean_data/BBGM.duckdb")

# Drop the table if it exists.
dbExecute(con, "DROP TABLE IF EXISTS game_results")
dbExecute(con, "DROP TABLE IF EXISTS game_player_results")
dbExecute(con, "DROP TABLE IF EXISTS player_results")

# Create the game_results table.
dbExecute(con, "
  CREATE TABLE game_results (
    gid INTEGER,
    season INTEGER,
    won_tid INTEGER,
    won_pts INTEGER,
    lost_tid INTEGER,
    lost_pts INTEGER,
    PRIMARY KEY (gid)
  );
")

# Create the game_player_results table.
dbExecute(con, "
  CREATE TABLE game_player_results (
    gid INTEGER,
    tid INTEGER,
    pid INTEGER,
    season INTEGER,
    name VARCHAR,
    pos VARCHAR,
    min DOUBLE,
    PRIMARY KEY (gid, tid, pid)
  );
")

# Create the player_results table.
dbExecute(con, "
  CREATE TABLE player_results (
    pid INTEGER,
    tid INTEGER,
    firstName VARCHAR,
    lastName VARCHAR,
    hgt INTEGER,
    stre INTEGER,
    spd INTEGER,
    jmp INTEGER,
    endu INTEGER,
    ins INTEGER,
    dnk INTEGER,
    ft INTEGER,
    fg INTEGER,
    tp INTEGER,
    diq INTEGER,
    oiq INTEGER,
    drb INTEGER,
    pss INTEGER,
    reb INTEGER,
    season INTEGER,
    pos VARCHAR,
    fuzz DOUBLE,
    ovr INTEGER,
    pot INTEGER,
    injuryIndex INTEGER,
    PRIMARY KEY (pid, tid)
  );
")

# Write the game_results table to the database.
dbWriteTable(con, "game_results", game_results, append = TRUE, row.names = FALSE)
dbWriteTable(con, "game_player_results", game_player_results, append = TRUE, row.names = FALSE)
dbWriteTable(con, "player_results", player_results, append = TRUE, row.names = FALSE)

# Disconnect from the DuckDB database.
dbDisconnect(con)