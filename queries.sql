-- get player count
SELECT COUNT(distinct uid) FROM cgs_gc_SpringMan_log.player_quests_log where cid = 300;

-- get counts of players ending levels
select qid, count(distinct uid) from cgs_gc_SpringMan_log.player_quests_log where cid = 300 and quest_seqid = 0 group by qid;

-- get play lengths for each user from all their sessions
select t.uid, sum(t.dms) as 'duration (ms)', sum(t.dm) as 'duration (m)'
from (select q.uid as 'uid', q.dqid as 'sid' , max(q.client_ts) as 'start', min(p.client_ts) as 'end', max(q.client_ts) - min(p.client_ts) as 'dms', (max(q.client_ts) - min(p.client_ts))/60000 as 'dm'
	from cgs_gc_SpringMan_log.player_quests_log q, cgs_gc_SpringMan_log.player_pageload_log p
    where q.sessionid = p.sessionid and q.cid = 300 and q.quest_seqid = 0
    group by q.uid, q.dqid) t
group by t.uid;


-- get return rate
select t.sessions, count(distinct t.uid) from (select uid, count(distinct sessionid) as 'sessions' from cgs_gc_SpringMan_log.player_pageload_log where cid = 300 group by uid) t group by t.sessions;

-- time per level
select qid, avg(convert(trim(trailing '}' from trim(leading '{"time":' from q_detail)), unsigned integer)) as 'time taken (ms)' from cgs_gc_SpringMan_log.player_quests_log where cid = 300 and quest_seqid = 0 group by qid;

SELECT 
    qid,
    AVG(CONVERT( SUBSTRING_INDEX(SUBSTRING(q_detail,
                LOCATE('"time":', q_detail) + 7),
            ',',
            1) , UNSIGNED INTEGER)) AS 'time taken (ms)'
FROM
    cgs_gc_SpringMan_log.player_quests_log
WHERE
    cid = 300 AND quest_seqid = 0
GROUP BY qid;


-- resets per level
SELECT qid, count(*) as 'Total Resets' FROM cgs_gc_SpringMan_log.player_actions_log where cid = 300 and aid = 2 group by qid;

-- springs per level
SELECT qid, count(*) as 'Total Springs' FROM cgs_gc_SpringMan_log.player_actions_log where cid = 300 and aid = 1 group by qid;

-- death per level
SELECT qid, count(*) as 'Total Deaths' FROM cgs_gc_SpringMan_log.player_actions_log where cid = 300 and aid = 3 group by qid;

-- rewind per level
SELECT qid, count(*) as 'Total Rewinds' FROM cgs_gc_SpringMan_log.player_actions_log where cid = 300 and aid = 8 group by qid;

-- avg resets per level
select t.qid, avg(t.resets) as 'Average Resets per Level' from (SELECT qid, dqid, count(*) as 'resets' FROM cgs_gc_SpringMan_log.player_actions_log where cid = 300 and aid = 2 group by qid, dqid) t group by t.qid;

-- avg springs per level
select t.qid, avg(t.springs) as 'Average Springs per Level' from (SELECT qid, dqid, count(*) as 'springs' FROM cgs_gc_SpringMan_log.player_actions_log where cid = 300 and aid = 1 group by qid, dqid) t group by t.qid;

-- avg deaths per level
select t.qid, avg(t.deaths) as 'Average Deaths per Level' from (SELECT qid, dqid, count(*) as 'deaths' FROM cgs_gc_SpringMan_log.player_actions_log where cid = 300 and aid = 3 group by qid, dqid) t group by t.qid;

-- springs to complete a level
SELECT 
    qid,
    AVG(CONVERT( SUBSTRING_INDEX(SUBSTRING(q_detail,
                LOCATE('"ts":', q_detail) + 5),
            ',',
            1) , UNSIGNED INTEGER)) AS 'Total Springs to Complete a Level'
FROM
    cgs_gc_SpringMan_log.player_quests_log
WHERE
    cid = 300 AND quest_seqid = 0
GROUP BY qid;

-- session played in a level
select qid, count(*) as 'Sessions' from (SELECT qid, dqid FROM cgs_gc_SpringMan_log.player_quests_log where cid = 100 group by qid, dqid) t group by qid;

-- number of starts to a level with no end
SELECT count(*) FROM cgs_gc_SpringMan_log.player_quests_log q1 where not exists (select dqid from cgs_gc_SpringMan_log.player_quests_log q2 where cid = 300 and q_s_id = 0 and q2.dqid = q1.dqid);

-- get start levels with no end levels
SELECT * FROM cgs_gc_SpringMan_log.player_quests_log q1 where not exists (select dqid from cgs_gc_SpringMan_log.player_quests_log q2 where cid = 300 and q_s_id = 0 and q2.dqid = q1.dqid) and q1.cid = 300;

-- number of starts with at least one action
SELECT 
    count(*)
FROM
    (SELECT 
        *
    FROM
        cgs_gc_SpringMan_log.player_quests_log q1
    WHERE
        NOT EXISTS( SELECT 
                dqid
            FROM
                cgs_gc_SpringMan_log.player_quests_log q2
            WHERE
                cid = 300 AND q_s_id = 0
                    AND q2.dqid = q1.dqid)
            AND q1.cid = 300) t1,
    (SELECT 
        dqid, MAX(ts), aid, qid
    FROM
        cgs_gc_SpringMan_log.player_actions_log
    WHERE
        cid = 300
    GROUP BY dqid) t2
WHERE
	t1.dqid = t2.dqid;
  
-- actions count for all sessions that only has starts
SELECT 
    t2.aid, count(*)
FROM
    (SELECT 
        *
    FROM
        cgs_gc_SpringMan_log.player_quests_log q1
    WHERE
        NOT EXISTS( SELECT 
                dqid
            FROM
                cgs_gc_SpringMan_log.player_quests_log q2
            WHERE
                cid = 300 AND q_s_id = 0
                    AND q2.dqid = q1.dqid)
            AND q1.cid = 300) t1,
    (SELECT 
        dqid, MAX(ts), aid, qid
    FROM
        cgs_gc_SpringMan_log.player_actions_log
    WHERE
        cid = 300
    GROUP BY dqid) t2
WHERE
	t1.dqid = t2.dqid
Group by
	t2.aid;
  
-- same as above only per level
SELECT 
    t2.qid, t2.aid, count(*)
FROM
    (SELECT 
        *
    FROM
        cgs_gc_SpringMan_log.player_quests_log q1
    WHERE
        NOT EXISTS( SELECT 
                dqid
            FROM
                cgs_gc_SpringMan_log.player_quests_log q2
            WHERE
                cid = 300 AND q_s_id = 0
                    AND q2.dqid = q1.dqid)
            AND q1.cid = 300) t1,
    (SELECT 
        dqid, MAX(ts), aid, qid
    FROM
        cgs_gc_SpringMan_log.player_actions_log
    WHERE
        cid = 300
    GROUP BY dqid) t2
WHERE
	t1.dqid = t2.dqid
Group by
	t2.qid, t2.aid;
  
-- get specific details
SELECT 
    t2.a_detail
FROM
    (SELECT 
        *
    FROM
        cgs_gc_SpringMan_log.player_quests_log q1
    WHERE
        NOT EXISTS( SELECT 
                dqid
            FROM
                cgs_gc_SpringMan_log.player_quests_log q2
            WHERE
                cid = 300 AND q_s_id = 0
                    AND q2.dqid = q1.dqid)
            AND q1.cid = 300) t1,
    (SELECT 
        dqid, MAX(ts), aid, qid, a_detail
    FROM
        cgs_gc_SpringMan_log.player_actions_log
    WHERE
        cid = 300
    GROUP BY dqid) t2
WHERE
	t1.dqid = t2.dqid
    and t2.qid = 6
    and t2.aid = 4;
    
-- get last actions of people who don;t finish a level
SELECT 
    a1.dqid, a1.a_detail, a1.aid, MAX(a1.client_ts)
FROM
    cgs_gc_SpringMan_log.player_actions_log a1,
    (SELECT 
        q1.dqid
    FROM
        cgs_gc_SpringMan_log.player_quests_log q1
    WHERE
        q1.cid = 302 AND q1.qid = 8
            AND NOT EXISTS( SELECT 
                q2.dqid AS 'dqid'
            FROM
                cgs_gc_SpringMan_log.player_quests_log q2
            WHERE
                q2.cid = 302 AND q2.qid = 8
                    AND q2.q_s_id = 0
                    AND q2.dqid = q1.dqid)) q
WHERE
    a1.cid = 302 AND a1.qid = 8
        AND q.dqid = a1.dqid
GROUP BY a1.dqid;

-- get the last level players end at
SELECT 
    pl.uid, MAX(ql.qid)
FROM
    cgs_gc_SpringMan_log.player_quests_log ql,
    (SELECT DISTINCT
        uid
    FROM
        cgs_gc_SpringMan_log.player_pageload_log
    WHERE
        cid = 400) pl
WHERE
    ql.cid = 400 AND pl.uid = ql.uid
        AND ql.q_s_id = 0
GROUP BY pl.uid;

-- get the count of players that finished only up to that level
SELECT 
    l.qid, COUNT(*) AS 'players'
FROM
    (SELECT 
        pl.uid, MAX(ql.qid) AS 'qid'
    FROM
        cgs_gc_SpringMan_log.player_quests_log ql, (SELECT DISTINCT
        uid
    FROM
        cgs_gc_SpringMan_log.player_pageload_log
    WHERE
        cid = 400) pl
    WHERE
        ql.cid = 400 AND pl.uid = ql.uid
            AND ql.q_s_id = 0
    GROUP BY pl.uid) l
GROUP BY l.qid;

-- get the number of unique players that started a level
SELECT count(distinct uid) FROM cgs_gc_SpringMan_log.player_quests_log where cid = 302 and q_s_id = 1;