
############################################################################
##
##                 Appendix 2: Python Script to Update Database
##
############################################################################


from os import walk
import re
import datetime
import mysql.connector as msc
import pandas as pd

## A class to update nba data
## Useage: first create a update object NBA_Update(user, password)
##         then call its method update_by_date(directory, date)
class NBA_Update(object):
    def __init__(self, user, password):
	## user, password to login to local 
	## database with schema nba
        self.user = user
        self.password = password
    
    def get_files(self, directory='nba/', date='.*'):
        self.files = []
        for (dirpath, dirnames, filenames) in walk(directory):
            r = re.compile("\[{0}\]".format(date))
            fs = filter(r.match, filenames) 
            self.files.extend([dirpath+f for f in fs])
    
    def compute_time(self, period=1, elapsed = '00:12:00'):
        h, m, s = elapsed.split(':')
        return h + ':' + str(int(m)+12*(period-1)).zfill(2) + ':' + s
    
    def update_schedule(self, f, data, cursor):
        away, home = re.findall(r'([A-Z]*)@([A-Z]*)',f)[0]
        date = re.findall(r'\[([0-9\-]*)\]',f)[0]
        gameid = re.findall(r'[0-9]+', str(data['game_id'][0]))[0]
        season = re.findall(r'(.*) Season', str(data['data_set'][0]))
        if season:
            season = season[0]
        else:
            season = str(data['data_set'][0])
        add_schedule = ("INSERT IGNORE INTO Schedule "
                        "(game_id, season, game_date, away_team, home_team) "
                        "VALUES (%s, %s, %s, %s, %s) ")
        entry = (gameid, season, date, away, home)
        cursor.execute(add_schedule, entry)
        return 
    
    def update_playfor(self, f, data, cursor):
        away, home = re.findall(r'([A-Z]*)@([A-Z]*)',f)[0]
        date = re.findall(r'\[([0-9\-]*)\-[0-9]+\]',f)[0]
        away_player = list(data['a1'].append(data['a2'])\
                                     .append(data['a3'])\
                                     .append(data['a4'])\
                                     .append(data['a5']).unique())
        home_player = list(data['h1'].append(data['h2'])\
                                     .append(data['h3'])\
                                     .append(data['h4'])\
                                     .append(data['h5']).unique())
        add_playfor = ("INSERT IGNORE INTO Play_For "
                       "(name, play_for, date_ym) "
                       "VALUES (%s, %s, %s) ")
        for p in away_player:
            cursor.execute(add_playfor, (p,away,date))
        for p in home_player:
            cursor.execute(add_playfor, (p,home,date))
        return
        
    def update_lineup(self, data, cursor):
        game_id = re.findall(r'[0-9]+', str(data['game_id'][0]))[0]
        add_lineup = ("INSERT IGNORE INTO Lineup "
                      "(game_id, start_time, end_time, "
                      " a1,a2,a3,a4,a5,h1,h2,h3,h4,h5) "
                      "VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s) ")
        lineup = []; timestamp = 0
        for index, row in data.iterrows():
            lu = [row['a1'],row['a2'],row['a3'],row['a4'],row['a5'],\
                  row['h1'],row['h2'],row['h3'],row['h4'],row['h5']]
            if not lu == lineup:
                current = self.compute_time(row['period'], row['elapsed'])
                if not lineup:
                    lineup, timestamp = lu, current
                else:
                    cursor.execute(add_lineup, [game_id, timestamp, current]+lu)
                    lineup, timestamp = lu, current
        current = self.compute_time(row['period'], row['elapsed'])
        cursor.execute(add_lineup, [game_id, timestamp, current]+lu)
        return
    
    def update_event(self, data, cursor):
        game_id = re.findall(r'[0-9]+', str(data['game_id'][0]))[0]
        add_event_time = ("INSERT IGNORE INTO Event_Time "
                          "(game_id, event_id, period, elapsed, play_length, "
                          " away_score, home_score, team, player) "
                          "VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s) ")
        add_jumpball = ("INSERT IGNORE INTO Jump_Ball "
                        "(game_id, event_id, away_player, home_player, possession)"
                        "VALUES (%s,%s,%s,%s,%s) ")
        add_shoot = ("INSERT IGNORE INTO Shoot "
                     "(game_id, event_id, type, result, "
                     " by_player, loc_x, loc_y, points) "
                     "VALUES (%s,%s,%s,%s,%s,%s,%s,%s) ")
        add_rebound = ("INSERT IGNORE INTO Rebound "
                       "(game_id, event_id, type)"
                       "VALUES (%s,%s,%s) ")
        add_freethrow = ("INSERT IGNORE INTO Free_Throw "
                         "(game_id, event_id, num, out_of, result)"
                         "VALUES (%s,%s,%s,%s,%s) ")
        add_turnover = ("INSERT IGNORE INTO Turnover "
                        "(game_id, event_id, reason, steal_by)"
                        "VALUES (%s,%s,%s,%s) ")
        add_foul = ("INSERT IGNORE INTO Foul "
                    "(game_id, event_id, type, opponent)"
                    "VALUES (%s,%s,%s,%s) ")
        add_violation = ("INSERT IGNORE INTO Violation "
                         "(game_id, event_id, type)"
                         "VALUES (%s,%s,%s) ")
        add_ejection = ("INSERT IGNORE INTO Ejection "
                        "(game_id, event_id)"
                        "VALUES (%s,%s) ")
        add_timeout = ("INSERT IGNORE INTO Timeout "
                       "(game_id, event_id)"
                       "VALUES (%s,%s) ")
        add_sub = ("INSERT IGNORE INTO Sub "
                   "(game_id, event_id, enter)"
                   "VALUES (%s,%s,%s) ")
        
        for index, row in data.iterrows():
            event_id = int(row['play_id'])
            period, elapsed = int(row['period']), row['elapsed']
            play_length = int(row['play_length'].split(':')[-1])
            away, home = int(row['away_score']),int(row['home_score'])
            team, player = row['team'], row['player']
            if pd.isna(team): team = None
            if pd.isna(player): player = None
            if row['event_type'] == 'timeout':
                team = re.findall(r'(.*) Timeout',row['description'])[0]
            
            cursor.execute(add_event_time,
                           (game_id,event_id,period,elapsed,\
                            play_length,away,home,team,player))
            
            if row['event_type'] == 'jump ball':
                a, h, p = row['away'],row['home'],row['possession']
                if pd.isna(a): a = None
                if pd.isna(h): h = None
                if pd.isna(p): p = None
                cursor.execute(add_jumpball,(game_id,event_id,a,h,p))
            elif row['event_type'] == 'shot' or row['event_type'] == 'miss':
                stype, points = row['type'], row['points']
                assist, block, res = row['assist'],row['block'],row['result']
                loc_x,loc_y = row['original_x'],row['original_y']
                if not pd.isna(assist):
                    cursor.execute(add_shoot,
                                   (game_id,event_id,stype,"assisted",\
                                    assist,loc_x,loc_y,points))
                elif not pd.isna(block):
                    cursor.execute(add_shoot,
                                   (game_id,event_id,stype,"blocked",\
                                    block,loc_x,loc_y,points))
                else:
                    cursor.execute(add_shoot,
                                   (game_id,event_id,stype,res,\
                                    None,loc_x,loc_y,points))
                
            elif row['event_type'] == 'rebound':
                cursor.execute(add_rebound,
                               (game_id,event_id,row['type']))
            elif row['event_type'] == 'free throw':
                cursor.execute(add_freethrow,
                               (game_id,event_id,row['num'],\
                                row['outof'],row['result']))
            elif row['event_type'] == 'turnover':
                steal, r = row['steal'], row['reason']
                if pd.isna(steal): steal = None
                if pd.isna(r): r = None
                cursor.execute(add_turnover, (game_id,event_id,r,steal))
            elif row['event_type'] == 'foul':
                t, o = row['type'],row['opponent']
                if pd.isna(t): t = None
                if pd.isna(o): o = None
                cursor.execute(add_foul,(game_id,event_id,t,o))
            elif row['event_type'] == 'violation':
                cursor.execute(add_violation,
                               (game_id,event_id,row['type']))
            elif row['event_type'] == 'ejection':
                cursor.execute(add_ejection, (game_id, event_id))
            elif row['event_type'] == 'timeout':
                cursor.execute(add_timeout, (game_id, event_id))
            elif row['event_type'] == 'sub':
                cursor.execute(add_sub, (game_id, event_id, row['entered']))
        return
    
    def update_by_date(self, directory='nba/', date='.*'):
	## update given date data in directory
        dbx = msc.connect(user=self.user, password=self.password,
                          host='127.0.0.1', database='nba')
        cursor = dbx.cursor()
        self.get_files(directory, date)
        try:
            for (i,f) in enumerate(self.files):
                if i % 100 == 0: print("num_files: ", i)
                data = pd.read_csv(f, encoding = 'latin1')
                self.update_schedule(f, data, cursor)
                self.update_playfor(f, data, cursor)
                self.update_lineup(data, cursor)
                self.update_event(data, cursor)
            dbx.commit()
            print("Success!")
        finally:
            cursor.close()
            dbx.close()

if __name__ == 'main':
    ## update all files
    ex = NBA_Update('bohao', '3316')
    ex.update_by_date()
