DELIMITER $$

CREATE PROCEDURE VerifyVoteResults(
    IN p_game_id INT      -- NULL이면 전체 게임
)
BEGIN
    -- 0) 테이블 건수 확인
    SELECT 'stadium' AS tbl, COUNT(*) AS cnt FROM stadium
    UNION ALL SELECT 'team', COUNT(*) FROM team
    UNION ALL SELECT 'user', COUNT(*) FROM `user`
    UNION ALL SELECT 'game', COUNT(*) FROM game
    UNION ALL SELECT 'vote', COUNT(*) FROM vote;

    -- 1) 미래 경기 투표/수정 예시 (game_id=5 기준)
    IF p_game_id IS NULL OR p_game_id = 5 THEN
        INSERT INTO vote (user_id, game_id, team_id, `date`)
        SELECT 1, 5, 5, NOW()
        FROM game g
        WHERE g.game_id = 5 AND NOW() < g.`date`
        ON DUPLICATE KEY UPDATE team_id = VALUES(team_id), `date` = NOW();
        SELECT ROW_COUNT() AS affected_after_insert_g5_u1;

        INSERT INTO vote (user_id, game_id, team_id, `date`)
        SELECT 1, 5, 2, NOW()
        FROM game g
        WHERE g.game_id = 5 AND NOW() < g.`date`
        ON DUPLICATE KEY UPDATE team_id = VALUES(team_id), `date` = NOW();
        SELECT ROW_COUNT() AS affected_after_update_g5_u1;
    END IF;

    -- 2) 과거 경기 투표/수정 차단 (game_id=1 기준)
    IF p_game_id IS NULL OR p_game_id = 1 THEN
        INSERT INTO vote (user_id, game_id, team_id, `date`)
        SELECT 2, 1, 1, NOW()
        FROM game g
        WHERE g.game_id = 1 AND NOW() < g.`date`
        ON DUPLICATE KEY UPDATE team_id = VALUES(team_id), `date` = NOW();
        SELECT ROW_COUNT() AS affected_past_game_should_be_zero;
    END IF;

    -- 3) 진행 중/미래 경기 현황 (game_id=5 기준)
    IF p_game_id IS NULL OR p_game_id = 5 THEN
        SELECT
            t.team_id, t.name AS team_name, COUNT(v.vote_id) AS votes
        FROM game g
        JOIN team t ON t.team_id IN (g.home_team_id, g.away_team_id)
        LEFT JOIN vote v ON v.game_id = g.game_id AND v.team_id = t.team_id
        WHERE g.game_id = 5
        GROUP BY t.team_id, t.name
        ORDER BY votes DESC, team_name;
    END IF;

    -- 4) 단일 경기 결과 (game_id 기준)
    IF p_game_id IS NOT NULL THEN
        SELECT
            t.team_id,
            t.name AS team_name,
            COUNT(v.vote_id) AS votes,
            ROUND(COUNT(v.vote_id) * 100.0 / NULLIF(tv.total_votes, 0), 2) AS pct
        FROM game g
        JOIN team t ON t.team_id IN (g.home_team_id, g.away_team_id)
        LEFT JOIN vote v
            ON v.game_id = g.game_id
           AND v.team_id = t.team_id
           AND v.`date` < g.`date`
        JOIN (
            SELECT COUNT(*) AS total_votes
            FROM vote
            WHERE game_id = p_game_id
              AND `date` < (SELECT `date` FROM game WHERE game_id = p_game_id)
        ) tv
        WHERE g.game_id = p_game_id
        GROUP BY t.team_id, t.name, tv.total_votes;
    END IF;

    -- 5) 역대 투표 결과 목록 (마감 기준)
    SELECT
        x.game_id,
        x.start_time,
        x.stadium_name,
        x.home_team,
        x.away_team,
        x.home_votes,
        x.away_votes,
        CASE WHEN x.home_votes >= x.away_votes THEN x.home_team ELSE x.away_team END AS leading_team,
        ROUND(GREATEST(x.home_votes, x.away_votes) * 100.0 / NULLIF(x.home_votes + x.away_votes, 0), 2) AS leading_pct
    FROM (
        SELECT
            g.game_id,
            g.`date` AS start_time,
            s.name AS stadium_name,
            ht.name AS home_team,
            at.name AS away_team,
            SUM(CASE WHEN v.team_id = g.home_team_id THEN 1 ELSE 0 END) AS home_votes,
            SUM(CASE WHEN v.team_id = g.away_team_id THEN 1 ELSE 0 END) AS away_votes
        FROM game g
        JOIN stadium s ON s.stadium_id = g.stadium_id
        JOIN team ht ON ht.team_id = g.home_team_id
        JOIN team at ON at.team_id = g.away_team_id
        LEFT JOIN vote v
            ON v.game_id = g.game_id
           AND v.`date` < g.`date`
        WHERE p_game_id IS NULL OR g.game_id = p_game_id
        GROUP BY g.game_id, g.`date`, s.name, ht.name, at.name
    ) AS x
    ORDER BY x.start_time DESC
    LIMIT 100;

    -- 6) 마감 이후 투표 체크
    SELECT
        g.game_id,
        SUM(CASE WHEN v.`date` >= g.`date` THEN 1 ELSE 0 END) AS count_invalid_votes
    FROM game g
    LEFT JOIN vote v ON v.game_id = g.game_id
    WHERE p_game_id IS NULL OR g.game_id = p_game_id
    GROUP BY g.game_id
    ORDER BY g.game_id;
END $$

DELIMITER ;
