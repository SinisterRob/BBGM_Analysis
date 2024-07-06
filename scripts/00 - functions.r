# Reads the raw game data.
read_game_data <- function(){
  readRDS("../data/BBGM.RDS")
}

# Scrapes the game-level results.
scrape_game_results <- function(json_data){
  json_data$games %>% 
    select(gid, season, won, lost) %>% 
    unnest(cols = c("won", "lost"), names_sep = c("_"))
}

# Scrapes the game/player-level results.
scrape_game_player_results <- function(json_data){
  
  # Set up games_data.
  games_data <- json_data$games
  
  # Initialize an empty list to store results
  game_player_results <- vector("list", nrow(games_data))
  
  # Loop over each game in games_data
  for (i in 1:nrow(games_data)) {
    game <- games_data[i, ]
    
    gid <- game$gid
    tid <- game$teams[[1]]$tid
    season <- game$season
    
    pt1 <- game$teams[[1]]$players[[1]]
    pt2 <- game$teams[[1]]$players[[2]]
    
    prt1 <- data.frame(
      gid = gid,
      tid = tid[[1]],
      pid = pt1$pid,
      season = season,
      name = pt1$name,
      pos = pt1$pos,
      min = pt1$min,
      stringsAsFactors = FALSE
    )
    
    prt2 <- data.frame(
      gid = gid,
      tid = tid[[2]],
      pid = pt2$pid,
      season = season,
      name = pt2$name,
      pos = pt2$pos,
      min = pt2$min,
      stringsAsFactors = FALSE
    )
    
    game_player_results[[i]] <- rbind(prt1, prt2)
  }
  
  # Combine all results into one data frame
  rbindlist(game_player_results)
}

# Scrapes the player-level results.
scrape_player_results <- function(json_data){
  players_data <- json_data$players
  
  player_results <- vector("list", nrow(players_data))
  
  for (i in 1:nrow(players_data)){
    player <- players_data[i, ]
    player_details <- player %>% 
      select(pid, tid, firstName, lastName)
    ratings <- player$ratings[[1]] %>% mutate(pid = player_details$pid)
    player_results[[i]] <- player_details %>% left_join(ratings, by = join_by("pid")) %>% filter(season == 2024) %>% select(-skills)
  }
  
  # Combine all results into one data frame
  rbindlist(player_results, fill = TRUE) %>% filter(is.na(injuryIndex))
}