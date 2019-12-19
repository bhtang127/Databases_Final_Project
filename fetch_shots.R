
fetch_shots_by_name = function(pname) {
  req(pname)
  
  nba = dbConnect(MySQL(), user='root', password='Sun2011304', dbname='nba', host='127.0.0.1')
  r1 = dbSendQuery(nba, paste0(
                  'select * from Shoot_Zone where player = \'',pname,'\';'
                  ))
  shots = fetch(r1, n=-1)
  
  la = dbSendQuery(nba, 'select * from League_Average;')
  league_averages = fetch(la, n=-1)
  
  
  on.exit(dbDisconnect(nba))
  
  return(list(player = shots, league_averages = league_averages))
}

stats_by_name = function(pname, s, e){
  nba = dbConnect(MySQL(), user='root', password='Sun2011304', dbname='nba', host='127.0.0.1')
  e1 = dbSendQuery(nba, paste0(
    'call selectstats(\'',s,'\',\'',e,'\',\'',pname,'\');'
  ))
  effi = fetch(e1, n=-1)
  on.exit(dbDisconnect(nba))
  
  effi
}

# res = fetch_shots_by_name('James Harden','2018-11-30','2018-12-15')


