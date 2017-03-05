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

CREATE VIEW v_winner_order AS select players.name, count(matches.winner) as num from players,matches where players.id = matches.winner group by players.id order by num desc;					  
CREATE VIEW v_wl AS SELECT players.id, players.name, sum(case when matches.winner = players.id then 1 else 0 end) wins, sum(case when matches.loser = players.id then 1 else 0 end) loses FROM matches, players GROUP BY players.id ORDER BY wins DESC;
CREATE VIEW v_total_match AS select v_wl.name, sum(wins+loses) as total_match from v_wl group by v_wl.name;
CREATE VIEW v_ranking AS select * from v_wl, v_total_match where v_wl.name = v_total_match.name;

insert into players (name) values ('brian');
insert into players (name) values ('elodie');
insert into players (name) values ('melila');
insert into players (name) values ('cindy');
insert into players (name) values ('duke');
insert into players (name) values ('bruce');
insert into players (name) values ('andy');
insert into players (name) values ('bloom');

insert into matches (winner, loser) values (1,3);
insert into matches (winner, loser) values (3,5);
insert into matches (winner, loser) values (1,5);
insert into matches (winner, loser) values (5,4);
insert into matches (winner, loser) values (1,6);
insert into matches (winner, loser) values (5,6);
insert into matches (winner, loser) values (2,3);
insert into matches (winner, loser) values (1,2);
insert into matches (winner, loser) values (2,4);
insert into matches (winner, loser) values (4,6);
insert into matches (winner, loser) values (5,3);
insert into matches (winner, loser) values (4,1);
