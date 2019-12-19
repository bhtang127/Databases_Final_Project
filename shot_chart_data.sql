use nba;

-- Creat view for shot zone information
drop view if exists Shoot_Zone;
create view Shoot_Zone as 
select *, (case when shot_distance <= 8 then 0
				when shot_distance > 8 and shot_distance <= 16 then ceiling((angle+90)/60)
                when shot_distance > 16 and loc_y <= 47 then ceiling((angle+90)/36)
                else 0 end) as shot_zone_area
from (
select *, (case when shot_distance <= 8 then 'Less Than 8 ft.'
			 when shot_distance > 8 and shot_distance <= 16 then '8-16 ft.'
             when shot_distance > 16 and shot_distance <= 24 then '16-24 ft.'
             when shot_distance > 24 and loc_y <= 47 then '24+ ft.'
             else 'Back Court Shot' end) as shot_zone_range, 
             atan(loc_y/(loc_x+1e-5))*180/pi() as angle
from (
select sqrt(power(loc_x/10,2) + power(loc_y/10,2)) as shot_distance,
	   loc_x/10 as loc_x, loc_y/10 + 5.25 as loc_y,
       (case when points > 0 then 1 else 0 end) as shot_made_numeric,
       points as shot_value, game_date, player, period
from Shoot, Schedule, Event_Time
where Shoot.game_id = Schedule.game_id
  and Event_Time.event_id = Shoot.event_id
  and Event_Time.game_id = Shoot.game_id
) AUX1
) AUX2;

-- select * from Shoot_Zone
-- where player = 'James Harden'
-- and game_date between '2018-12-12' and '2019-05-01';

-- create summary table for league_average
drop table if exists League_Average;
create table League_Average as
select shot_zone_area, shot_zone_range,
	   count(*) as fga, sum(shot_made_numeric) as fgm,
       avg(shot_made_numeric) as fg_pct
from Shoot_Zone
group by 1,2;

-- select * from League_Average;
