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
					  
CREATE VIEW v_wins AS select players.id, count(matches.winner) as wins from players left join matches on players.id = matches.winner group by players.id;

CREATE VIEW v_total AS  select players.id, count(matches) total from players left join matches on players.id = matches.winner or players.id = matches.loser group by players.id;

CREATE VIEW v_tuple AS select players.id, players.name, v_wins.wins, v_total.total from players,v_wins,v_total where players.id = v_wins.id and players.id = v_total.id group by players.id, v_wins.wins, v_total.total order by v_wins.wins desc;

