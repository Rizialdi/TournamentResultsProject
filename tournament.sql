-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.
DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament

CREATE TABLE players (id SERIAL PRIMARY KEY,
					  name TEXT NOT NULL);
						
CREATE TABLE matches (id SERIAL PRIMARY KEY,
					  winner INTEGER REFERENCES players(id),
					  loser INTEGER REFERENCES players(id));	
					  
CREATE VIEW v_wl AS SELECT players.id, players.name, sum(case when matches.winner = players.id then 1 else 0 end) wins, sum(case when matches.loser = players.id or matches.winner = players.id then 1 else 0 end) total FROM players,matches GROUP BY players.id ORDER BY wins DESC;


