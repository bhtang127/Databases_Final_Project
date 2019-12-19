
---------------------------------------------------------------
------------------Appendix 1:  Database Creation---------------
---------------------------------------------------------------


use nba;

drop table if exists Players; 
create table Players (
    name              VARCHAR(30) not null, 
    primary key (name)
);

drop table if exists Play_For; 
create table Play_For (
    name              VARCHAR(30),
    play_for          VARCHAR(4),
    date_ym           VARCHAR(20),
    primary key (name, play_for, date_ym)
);

drop table if exists Teams; 
create table Teams (
    team_name         VARCHAR(15) not null,
    city              VARCHAR(15),
    abbrev            VARCHAR(4) not null,
    primary key (abbrev)
);

drop table if exists Schedule;
create table Schedule (
    game_id           VARCHAR(10) not null,
    season            VARCHAR(20),
    game_date         VARCHAR(15),
    away_team         VARCHAR(4),
    home_team         VARCHAR(4),
    primary key (game_id)
);

drop table if exists Lineup;
create table Lineup (
    game_id           VARCHAR(10) not null,
    start_time        VARCHAR(10) not null,
    end_time          VARCHAR(10),
    a1                VARCHAR(30),
    a2                VARCHAR(30),
    a3                VARCHAR(30),
    a4                VARCHAR(30),
    a5                VARCHAR(30),
    h1                VARCHAR(30),
    h2                VARCHAR(30),
    h3                VARCHAR(30),
    h4                VARCHAR(30),
    h5                VARCHAR(30),
    primary key (game_id, start_time)
);

drop table if exists Event_Time;
create table Event_Time (
    game_id           VARCHAR(10) not null,
    event_id          INTEGER not null,
    period            INTEGER,
    elapsed           VARCHAR(10),
    play_length       INTEGER,
    away_score        INTEGER,
    home_score        INTEGER,
    team              VARCHAR(4),
    player            VARCHAR(30),
    primary key (game_id, event_id)
);

drop table if exists Jump_Ball;
create table Jump_Ball (
    game_id           VARCHAR(10) not null,
    event_id          INTEGER not null,
    away_player       VARCHAR(30),
    home_player       VARCHAR(30),
    possession        VARCHAR(30),
    primary key (game_id, event_id)
);

drop table if exists Shoot;
create table Shoot (
    game_id           VARCHAR(10) not null,
    event_id          INTEGER not null,
    type              VARCHAR(40),
    result            VARCHAR(10),
    by_player         VARCHAR(30),
    loc_x             INTEGER,
    loc_y             INTEGER,
    points            INTEGER,
    primary key (game_id, event_id)
);

drop table if exists Rebound;
create table Rebound (
    game_id           VARCHAR(10) not null,
    event_id          INTEGER not null,
    type              VARCHAR(30),
    primary key (game_id, event_id)
);

drop table if exists Turnover;
create table Turnover (
    game_id           VARCHAR(10) not null,
    event_id          INTEGER not null,
    reason            VARCHAR(40),
    steal_by          VARCHAR(30),
    primary key (game_id, event_id)
);

drop table if exists Foul;
create table Foul (
    game_id           VARCHAR(10) not null,
    event_id          INTEGER not null,
    type              VARCHAR(40),
    opponent          VARCHAR(30),
    primary key (game_id, event_id)
);

drop table if exists Violation;
create table Violation (
    game_id           VARCHAR(10) not null,
    event_id          INTEGER not null,
    type              VARCHAR(40),
    primary key (game_id, event_id)
);

drop table if exists Ejection;
create table Ejection (
    game_id           VARCHAR(10) not null,
    event_id          INTEGER not null,
    primary key (game_id, event_id)
);

drop table if exists Timeout;
create table Timeout (
    game_id           VARCHAR(10) not null,
    event_id          INTEGER not null,
    primary key (game_id, event_id)
);

drop table if exists Free_Throw;
create table Free_Throw (
    game_id           VARCHAR(10) not null,
    event_id          INTEGER not null,
    num               INTEGER,
    out_of            INTEGER,
    result            INTEGER,
    primary key (game_id, event_id)
);

drop table if exists Sub;
create table Sub (
    game_id           VARCHAR(10) not null,
    event_id          INTEGER not null,
    enter             VARCHAR(30),
    primary key (game_id, event_id)
);
