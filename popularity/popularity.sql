DELIMITER $$

CREATE PROCEDURE GetWeeklyTeamPopularity(
    IN p_week_start DATE
)
BEGIN
    DECLARE week_start DATE;
    DECLARE week_end DATE;

    SET week_start = p_week_start;
    SET week_end   = DATE_ADD(week_start, INTERVAL 7 DAY);

    -- 임시 테이블: 주간 점수 계산
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_team_points (
        team_id INT PRIMARY KEY,
        points INT
    );

    TRUNCATE TABLE tmp_team_points;

    INSERT INTO tmp_team_points (team_id, points)
    SELECT
        u.team_id,
        COALESCE(SUM(CASE pl.action
            WHEN 'insert' THEN pl.fluctuation
            WHEN 'delete' THEN -pl.fluctuation
        END), 0) AS points
    FROM point_log pl
    JOIN `user` u ON u.user_id = pl.user_id
    WHERE pl.created_at >= week_start
      AND pl.created_at < week_end
    GROUP BY u.team_id;

    -- team_popularity 테이블에 업데이트 (주간 점수 저장)
    INSERT INTO team_popularity (team_id, `date`, point, created_at, updated_at)
    SELECT
        t.team_id,
        week_start,
        t.points,
        CURRENT_TIMESTAMP,
        NULL
    FROM tmp_team_points t
    ON DUPLICATE KEY UPDATE
        point = VALUES(point),
        updated_at = CURRENT_TIMESTAMP;

    -- 최종 결과: 점수 순위 계산
    SELECT
        t.team_id,
        tm.name AS team_name,
        t.points,
        RANK() OVER (ORDER BY t.points DESC) AS rank
    FROM tmp_team_points t
    JOIN team tm ON tm.team_id = t.team_id
    ORDER BY rank;

END $$

DELIMITER ;
