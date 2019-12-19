
-- total score
drop view if exists PTS;
create view PTS as 
select sum(points) as total_score, player , rank() over(order by sum(points) desc) as 'rank'
from shoot,event_time,schedule,command_time
where shoot.event_id=event_time.event_id
and shoot.game_id=schedule.game_id
and shoot.game_id=event_time.game_id
and schedule.game_date < et
and schedule.game_date > st
group by player;


-- total rebounds
drop view if exists rb;
create view rb as 
select count(event_time.event_id) as total_rebounds, player, rank() over(order by count(event_time.event_id) desc) as 'rank'
from rebound,event_time,schedule,command_time
where rebound.event_id=event_time.event_id
and rebound.game_id=schedule.game_id
and schedule.game_id=event_time.game_id
and schedule.game_date < et
and schedule.game_date > st
group by player;

-- total defensive rebound
drop view if exists drb;
create view drb as 
select count(event_time.event_id) as drb, player, rank() over(order by count(event_time.event_id) desc) as 'rank'
from rebound,event_time,schedule,command_time
where rebound.event_id=event_time.event_id
and rebound.game_id=schedule.game_id
and schedule.game_id=event_time.game_id
and type='rebound defensive'
and schedule.game_date < et
and schedule.game_date > st
group by player;

-- total offensive rebound
drop view if exists orb;
create view orb as 
select count(event_time.event_id) as orb, player, rank() over(order by count(event_time.event_id) desc) as 'rank'
from rebound,event_time,schedule,command_time
where rebound.event_id=event_time.event_id
and rebound.game_id=schedule.game_id
and schedule.game_id=event_time.game_id
and type='rebound offensive'
and schedule.game_date < et
and schedule.game_date > st
group by player;

-- playing time as a1
drop view if exists timea1;
create view timea1 as
select (sum((cast(substring_index(end_time,':',1) as signed)-cast(substring_index(start_time,':',1) as signed))*3600 +
(cast(substring_index(substring_index(end_time,':',-2),':',1) as signed)-cast(substring_index(substring_index(start_time,':',-2),':',1) as signed))*60 +
(cast(substring_index(end_time,':',-1) as signed)-cast(substring_index(start_time,':',-1) as signed)))) as a1, a1 as player
from lineup ,schedule,command_time
where lineup.game_id=schedule.game_id
and schedule.game_date < et
and schedule.game_date > st
group by a1;

-- playing time as a2
drop view if exists timea2;
create view timea2 as
select (sum((cast(substring_index(end_time,':',1) as signed)-cast(substring_index(start_time,':',1) as signed))*3600 +
(cast(substring_index(substring_index(end_time,':',-2),':',1) as signed)-cast(substring_index(substring_index(start_time,':',-2),':',1) as signed))*60 +
(cast(substring_index(end_time,':',-1) as signed)-cast(substring_index(start_time,':',-1) as signed)))) as a2, a2 as player
from lineup,schedule,command_time
where lineup.game_id=schedule.game_id
and schedule.game_date < et
and schedule.game_date > st
group by a2;

-- playing time as a3
drop view if exists timea3;
create view timea3 as
select (sum((cast(substring_index(end_time,':',1) as signed)-cast(substring_index(start_time,':',1) as signed))*3600 +
(cast(substring_index(substring_index(end_time,':',-2),':',1) as signed)-cast(substring_index(substring_index(start_time,':',-2),':',1) as signed))*60 +
(cast(substring_index(end_time,':',-1) as signed)-cast(substring_index(start_time,':',-1) as signed)))) as a3, a3 as player
from lineup,schedule,command_time
where lineup.game_id=schedule.game_id
and schedule.game_date < et
and schedule.game_date > st
group by a3;

-- playing time as a4
drop view if exists timea4;
create view timea4 as
select (sum((cast(substring_index(end_time,':',1) as signed)-cast(substring_index(start_time,':',1) as signed))*3600 +
(cast(substring_index(substring_index(end_time,':',-2),':',1) as signed)-cast(substring_index(substring_index(start_time,':',-2),':',1) as signed))*60 +
(cast(substring_index(end_time,':',-1) as signed)-cast(substring_index(start_time,':',-1) as signed)))) as a4, a4 as player
from lineup,schedule,command_time
where lineup.game_id=schedule.game_id
and schedule.game_date < et
and schedule.game_date > st
group by a4;


-- playing time as a5
drop view if exists timea5;
create view timea5 as
select (sum((cast(substring_index(end_time,':',1) as signed)-cast(substring_index(start_time,':',1) as signed))*3600 +
(cast(substring_index(substring_index(end_time,':',-2),':',1) as signed)-cast(substring_index(substring_index(start_time,':',-2),':',1) as signed))*60 +
(cast(substring_index(end_time,':',-1) as signed)-cast(substring_index(start_time,':',-1) as signed)))) as a5, a5 as player
from lineup,schedule,command_time
where lineup.game_id=schedule.game_id
and schedule.game_date < et
and schedule.game_date > st
group by a5;

-- playing time as h1
drop view if exists timeh1;
create view timeh1 as
select (sum((cast(substring_index(end_time,':',1) as signed)-cast(substring_index(start_time,':',1) as signed))*3600 +
(cast(substring_index(substring_index(end_time,':',-2),':',1) as signed)-cast(substring_index(substring_index(start_time,':',-2),':',1) as signed))*60 +
(cast(substring_index(end_time,':',-1) as signed)-cast(substring_index(start_time,':',-1) as signed)))) as h1, h1 as player
from lineup,schedule,command_time
where lineup.game_id=schedule.game_id
and schedule.game_date < et
and schedule.game_date > st
group by h1;

-- playing time as h2
drop view if exists timeh2;
create view timeh2 as
select (sum((cast(substring_index(end_time,':',1) as signed)-cast(substring_index(start_time,':',1) as signed))*3600 +
(cast(substring_index(substring_index(end_time,':',-2),':',1) as signed)-cast(substring_index(substring_index(start_time,':',-2),':',1) as signed))*60 +
(cast(substring_index(end_time,':',-1) as signed)-cast(substring_index(start_time,':',-1) as signed)))) as h2, h2 as player
from lineup,schedule,command_time
where lineup.game_id=schedule.game_id
and schedule.game_date < et
and schedule.game_date > st
group by h2;

-- playing time as h3
drop view if exists timeh3;
create view timeh3 as
select (sum((cast(substring_index(end_time,':',1) as signed)-cast(substring_index(start_time,':',1) as signed))*3600 +
(cast(substring_index(substring_index(end_time,':',-2),':',1) as signed)-cast(substring_index(substring_index(start_time,':',-2),':',1) as signed))*60 +
(cast(substring_index(end_time,':',-1) as signed)-cast(substring_index(start_time,':',-1) as signed)))) as h3, h3 as player
from lineup,schedule,command_time
where lineup.game_id=schedule.game_id
and schedule.game_date < et
and schedule.game_date > st
group by h3;

-- playing time as h4
drop view if exists timeh4;
create view timeh4 as
select (sum((cast(substring_index(end_time,':',1) as signed)-cast(substring_index(start_time,':',1) as signed))*3600 +
(cast(substring_index(substring_index(end_time,':',-2),':',1) as signed)-cast(substring_index(substring_index(start_time,':',-2),':',1) as signed))*60 +
(cast(substring_index(end_time,':',-1) as signed)-cast(substring_index(start_time,':',-1) as signed)))) as h4, h4 as player
from lineup,schedule,command_time
where lineup.game_id=schedule.game_id
and schedule.game_date < et
and schedule.game_date > st
group by h4;


-- playing time as h5
drop view if exists timeh5;
create view timeh5 as
select (sum((cast(substring_index(end_time,':',1) as signed)-cast(substring_index(start_time,':',1) as signed))*3600 +
(cast(substring_index(substring_index(end_time,':',-2),':',1) as signed)-cast(substring_index(substring_index(start_time,':',-2),':',1) as signed))*60 +
(cast(substring_index(end_time,':',-1) as signed)-cast(substring_index(start_time,':',-1) as signed)))) as h5, h5 as player
from lineup,schedule,command_time
where lineup.game_id=schedule.game_id
and schedule.game_date < et
and schedule.game_date > st
group by h5;

-- total away time
drop view if exists amp;
create view amp as
select distinct name as player, a1+a2+a3+a4+a5 as amp
from timea1,timea2,timea3,timea4, timea5, play_for
where timea1.player=name
and timea2.player=name
and timea3.player=name
and timea4.player=name
and timea5.player=name;

-- total home time
drop view if exists hmp;
create view hmp as
select distinct name as player, h1+h2+h3+h4+h5 as hmp
-- from timea1,timea2,timea3,timea4,timea5,timeh1,timeh2,timeh3,timeh4,timeh5,play_for 
from timeh1,timeh2,timeh3,timeh4, timeh5, play_for
where timeh1.player= name
and timeh2.player=name
and timeh3.player=name
and timeh4.player=name
and timeh5.player=name;

-- minutes of play
drop view if exists mp;
create view mp as
select distinct amp.player, (hmp+amp)/60 as mp, rank() over(order by (hmp+amp)/60 desc) as 'rank'
from hmp,amp
where hmp.player=amp.player;

-- total steal
drop view if exists stl;
create view stl as
select count(steal_by) as stl,steal_by as player, rank() over(order by count(steal_by) desc) as 'rank'
from turnover,schedule,command_time
where turnover.game_id = schedule.game_id
and schedule.game_date < et
and schedule.game_date > st
group by steal_by;

-- total blocks
drop view if exists blk;
create view blk as
select count(by_player) as blk, by_player as player, rank() over(order by count(by_player) desc) as 'rank'
from shoot,schedule,command_time
where shoot.game_id=schedule.game_id
and shoot.points=0
and schedule.game_date < et
and schedule.game_date > st
group by by_player;

-- total Turnover
drop view if exists tto;
create view tto as
select count(turnover.event_id) as tto, player as player, rank() over(order by count(turnover.event_id) asc) as 'rank'
from turnover,event_time,schedule,command_time
where turnover.game_id=schedule.game_id
and turnover.game_id=event_time.game_id
and turnover.event_id=event_time.event_id
and schedule.game_date < et
and schedule.game_date > st
group by player;

-- total shots
drop view if exists shots;
create view shots as
select count(player) as total_shots, player, rank() over(order by count(player) desc) as 'rank'
from event_time, shoot,schedule,command_time
where event_time.event_id=shoot.event_id
and event_time.game_id=shoot.game_id
and event_time.game_id=schedule.game_id
and schedule.game_date < et
and schedule.game_date > st
group by player;

-- Below are all for Hollinger Efficiency (uper)

-- total field goal made
drop view if exists fg;
create view fg as
select count(player) as fg, player, rank() over(order by count(player) desc) as 'rank'
from event_time, shoot,schedule,command_time
where event_time.event_id=shoot.event_id
and event_time.game_id=shoot.game_id
and event_time.game_id=schedule.game_id
and shoot.points>0
and schedule.game_date < et
and schedule.game_date > st
group by player;

-- total free throw made
drop view if exists ft;
create view ft as
select sum(num) as ft, sum(out_of) as fta, player, rank() over(order by sum(num) desc) as 'rank'
from event_time, free_throw,schedule,command_time
where event_time.event_id=free_throw.event_id
and event_time.game_id=free_throw.game_id
and event_time.game_id=schedule.game_id
and schedule.game_date < et
and schedule.game_date > st
group by player;

-- three points made
drop view 3p;
create view 3p as
select count(player) as 3p, player, rank() over(order by count(player) desc) as 'rank'
from event_time, shoot,schedule,command_time
where event_time.event_id=shoot.event_id
and event_time.game_id=shoot.game_id
and event_time.game_id=schedule.game_id
and shoot.points=3
and schedule.game_date < et
and schedule.game_date > st
group by player;

-- total assists
drop view if exists ast;
create view ast as
select count(points) as total_assist, by_player as player, rank() over(order by count(points) desc) as 'rank'
from shoot,event_time,schedule,command_time
where shoot.event_id=event_time.event_id
and shoot.game_id=schedule.game_id
and shoot.game_id=event_time.game_id
and shoot.points>0
and schedule.game_date < et
and schedule.game_date > st
group by by_player;

-- assists in league
drop view if exists lgast;
create view lgast as
select count(points) as total_assist
from shoot,event_time,schedule,command_time
where shoot.event_id=event_time.event_id
and shoot.game_id=schedule.game_id
and shoot.game_id=event_time.game_id
and shoot.points>0
and not by_player is null
and schedule.game_date < et
and schedule.game_date > st;

-- shots made in league
drop view if exists lgfg;
create view lgfg as
select count(points) as total_fg
from shoot,event_time,schedule,command_time
where shoot.event_id=event_time.event_id
and shoot.game_id=schedule.game_id
and shoot.game_id=event_time.game_id
and shoot.points>0
and schedule.game_date < et
and schedule.game_date > st;

-- shots in league
drop view if exists lgft;
create view lgft as
select count(points) as total_ft
from shoot,event_time,schedule,command_time
where shoot.event_id=event_time.event_id
and shoot.game_id=schedule.game_id
and shoot.game_id=event_time.game_id
and schedule.game_date < et
and schedule.game_date > st;


-- league's average scoring efficienct
drop view if exists factor;
create view factor as 
select 2/3-(0.5*(total_assist/total_fg))/(2*(total_fg/total_ft)) as factor
from lgast,lgfg,lgft;

-- team's assists
drop view if exists tmast;
create view tmast as
select count(points) as total_assist, play_for.play_for as team
from shoot,event_time,schedule,play_for,command_time
where shoot.event_id=event_time.event_id
and shoot.game_id=schedule.game_id
and shoot.game_id=event_time.game_id
and shoot.points>0
and not by_player is null
and by_player=play_for.name
and schedule.game_date < et
and schedule.game_date > st
group by play_for.play_for;

-- team's fg
drop view if exists tmfg;
create view tmfg as
select count(points) as tmfg, play_for.play_for as team
from shoot,event_time,schedule,play_for,command_time
where shoot.event_id=event_time.event_id
and shoot.game_id=schedule.game_id
and shoot.game_id=event_time.game_id
and shoot.points>0
and by_player=play_for.name
and schedule.game_date < et
and schedule.game_date > st
group by play_for.play_for;

-- efficiency in assists
drop view if exists t3;
create view t3 as
select distinct (2-factor*(tmast.total_assist/tmfg))*fg as t3, fg.player
from factor,tmast,tmfg,play_for,fg
where play_for.name=fg.player
and play_for.play_for=tmast.team
and play_for.play_for=tmfg.team;

-- effiency in free throw
drop view if exists t4;
create view t4 as
select distinct (2-(1/3)*(tmast.total_assist/tmfg))*0.5*ft as t4, ft.player
from tmast,tmfg,play_for,ft
where play_for.name=ft.player
and play_for.play_for=tmast.team
and play_for.play_for=tmfg.team;


-- league average points
drop view if exists LgPTS;
create view LgPTS as 
select sum(total_score)/count(total_score) as LgPTS
from PTS;

-- league average shots
drop view if exists LgFGA;
create view LgFGA as 
select sum(total_shots)/count(total_shots) as LgFGA
from shots;

-- league average offensive rebounds
drop view if exists LgORB;
create view LgORB as 
select sum(orb)/count(orb) as LgORB
from orb;

-- league average turnover
drop view if exists LgTO;
create view LgTO as 
select sum(tto)/count(tto) as LgTO
from tto;

-- league average total free thow
drop view if exists LgFTA;
create view LgFTA as 
select sum(fta)/count(fta) as LgFTA, sum(ft)/count(ft) as LgFT
from ft;

-- VOP  league average offensive efficiency
drop view if exists vop;
create view vop as 
select LgPTS/(LgFGA-LgORB+LgTO+0.44*LgFTA) as vop
from LgPTS,LgFGA,LgORB,LgTO,LgFTA;

-- effiency in turnover
drop view if exists t5;
create view t5 as
select player, (-tto*vop) as t5
from tto,vop;

-- league average rebounds
drop view if exists LgTRB;
create view LgTRB as 
select sum(total_rebounds)/count(total_rebounds) as LgTRB
from rb;

-- league average defensive rebound efficiency
drop view if exists DRBP;
create view DRBP as 
select (LgTRB-LgORB)/LgTRB as DRBP
from LgORB,LgTRB;

-- efficiency in offensive-defensive switching
drop view if exists t6;
create view t6 as
select fg.player, -vop*DRBP*(total_shots-fg) as t6
from DRBP,vop,fg,shots
where fg.player=shots.player;

-- efficiency in offensive-defensive switching (free throw)
drop view if exists t7;
create view t7 as
select player, -vop*0.44*(0.44+(0.56*DRBP))*(fta-ft) as t7
from DRBP,vop,ft
;

-- efficiency in defensive rebounds
drop view if exists t8;
create view t8 as
select rb.player, vop*(1-DRBP)*(total_rebounds-orb) as t8
from DRBP,vop,rb,orb
where rb.player=orb.player
;
-- efficiency in offensive rebounds
drop view if exists t9;
create view t9 as
select player, vop*DRBP*orb as t9
from DRBP,vop,orb
;

-- efficiency in steal
drop view if exists t10;
create view t10 as
select player, vop*stl as t10
from vop,stl;

-- efficiency in blocks
drop view if exists t11;
create view t11 as
select player, vop*DRBP*blk as t11
from vop,DRBP,blk;

-- fouls
drop view if exists pf;
create view pf as
select player, count(foul.event_id) as pf, rank() over(order by count(foul.event_id) asc) as 'rank'
from event_time,foul,schedule,command_time
where event_time.event_id=foul.event_id
and event_time.game_id=foul.game_id
and schedule.game_id = event_time.game_id 
and schedule.game_date < et
and schedule.game_date > st
group by event_time.player;

-- league average foul
drop view if exists Lgpf;
create view Lgpf as
select sum(pf)/count(pf) as Lgpf
from pf;

-- efficiency in fouls
drop view if exists t12;
create view t12 as
select pf.player, -(pf*((Lgft/Lgpf)-0.44*(lgfta/Lgpf)*vop)) as t12
from pf,lgfta,vop,Lgpf;


-- first six terms for hollinger efficiency
drop view if exists uper_16;
create view uper_16 as 
select 3p.player, 3p+(2/3)*total_assist+t3+t4+t5+t6 as uper_16
from 3p,ast,t3,t4,t5,t6
where 3p.player=ast.player
and 3p.player=t3.player
and 3p.player=t4.player
and 3p.player=t5.player
and 3p.player=t6.player;

-- last six terms for hollinger efficiency
drop view if exists uper_712;
create view uper_712 as 
select t7.player, t7+t8+t9+t10+t11+t12 as uper_712
from t7,t8,t9,t10,t11,t12
where t7.player=t8.player
and t7.player=t9.player
and t7.player=t10.player
and t7.player=t11.player
and t7.player=t12.player;


-- hollinger efficiency
drop view if exists uper;
create view uper as 
select mp.player, (uper_16+uper_712)/mp as uper, rank() over(order by (uper_16+uper_712)/mp desc) as 'rank'
from uper_16,uper_712,mp
where mp.player=uper_16.player
and mp.player=uper_712.player;

-- select *
-- from uper;