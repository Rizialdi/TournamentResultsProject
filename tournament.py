#!/usr/bin/env python
# 
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2


def connect(database_name="tournament"):
    try:
        db = psycopg2.connect("dbname={}".format(database_name))
        cursor = db.cursor()
        return db, cursor
    except:
        print("<error message>")


def deleteMatches():
    """Remove all the match records from the database."""
    sql_stat = "DELETE FROM matches;"
    db, cursor = connect()
    cursor.execute(sql_stat)
    cursor.close()
    db.close()

def deletePlayers():
    """Remove all the player records from the database."""
   #sql_stat = "TRUNCATE players CASCADE;"
    sql_stat = "DELETE FROM players;"
    db, cursor = connect()
    cursor.execute(sql_stat)
    db.commit()
    cursor.close()
    db.close()

def countPlayers():
    """Returns the number of players currently registered."""
    sql_stat = "SELECT count(*) FROM players;"
    db, cursor = connect()
    cursor.execute(sql_stat)
    num = cursor.fetchone()[0]
    cursor.close()
    db.close()
    return num


def registerPlayer(name):
    """Adds a player to the tournament database.
  
    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)
  
    Args:
      name: the player's full name (need not be unique).
    """
    db, cursor = connect()
    sql_stat = "INSERT INTO players (name) VALUES (%s);"
    parameter = (name,)
    cursor.execute(sql_stat, parameter)
    db.commit()
    db.close()



def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.

    The first entry in the list should be the player in first place, or a player
    tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """
    sql_stat = "SELECT * FROM v_wl"
    db, cursor = connect()
    cursor.execute(sql_stat)
    num = cursor.fetchall()
    cursor.close()
    db.close()
    return num


def reportMatch(winner, loser):
    """Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """
    sql_stat = "INSERT INTO matches (winner, loser) VALUES (%s, %s);"
    db, cursor = connect()
    parameter = (winner, loser)
    cursor.execute(sql_stat, parameter)
    db.commit()
    cursor.close()
    db.close() 
 
def swissPairings():
    """Returns a list of pairs of players for the next round of a match.
  
    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.
  
    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """


