-- use nba;


delimiter //
drop procedure if exists command//
CREATE DEFINER=`root`@`localhost` PROCEDURE `command`(s varchar(30), e   VARCHAR(30) )
BEGIN
	update command_time
    set st= s, et=e
    where ind=1;
END //

drop procedure if exists selectall//
CREATE DEFINER=`root`@`localhost` PROCEDURE `selectall`(s varchar(30), e   VARCHAR(30), p VARCHAR(50))
BEGIN
	call command(s,e);
	-- execute nba_statistics;  
    select total_score as PTS, PTS.rank as rankPTS, total_assist as AST, ast.rank as rankAST, total_rebounds as TRB, rb.rank as rankTRB, stl as STL, stl.rank as rankSTL, uper as UPER, uper.rank as rankUPER 
	from PTS, ast, rb, stl, uper
    where PTS.player= p
    and ast.player=p
    and rb.player=p
    and stl.player=p
    and uper.player= p;
END //

-- This version is the one without Holliger Efficiency (uper), suggested for computer without large space.

drop procedure if exists selectstats//
CREATE DEFINER=`root`@`localhost` PROCEDURE `selectstats`(s varchar(30), e   VARCHAR(30), p VARCHAR(50))
BEGIN
     call command(s,e);
 	-- execute nba_statistics;  
     select total_score as PTS, PTS.rank as rankPTS, total_assist as AST, ast.rank as rankAST, total_rebounds as TRB, rb.rank as rankTRB, stl as STL, stl.rank as rankSTL
 	from PTS, ast, rb, stl
     where PTS.player= p
     and ast.player=p
     and rb.player=p
     and stl.player=p;
END //



delimiter ;

call  selectall('2019-03-01','2019-04-01','James Harden');

