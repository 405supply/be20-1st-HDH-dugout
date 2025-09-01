DELIMITER $$

CREATE PROCEDURE ManagePlayerRating(
    IN p_action VARCHAR(20),   -- 'upsert', 'delete', 'team_list', 'player_detail', 'summary'
    IN p_player_id INT,        -- 특정 선수 ID
    IN p_user_id INT,          -- 투표 유저 ID
    IN p_score DECIMAL(5,2),  -- 투표 점수
    IN p_team_id INT,          -- 팀 ID (팀별 리스트)
    IN p_limit INT,            -- LIMIT
    IN p_offset INT            -- OFFSET
)
BEGIN
    -- 0) 뷰 생성 (없으면 재생성)
    DROP VIEW IF EXISTS v_player_with_rating;
    DROP VIEW IF EXISTS v_player_rating_summary;

    CREATE OR REPLACE VIEW v_player_rating_summary AS
    SELECT
        pg.player_id,
        ROUND(AVG(CASE WHEN pg.is_deleted = FALSE THEN pg.score END), 2) AS avg_score,
        COUNT(CASE WHEN pg.is_deleted = FALSE THEN 1 END)               AS rating_count
    FROM player_grade pg
    GROUP BY pg.player_id;

    CREATE OR REPLACE VIEW v_player_with_rating AS
    SELECT
        p.player_id,
        p.name,
        p.team_id,
        COALESCE(s.avg_score, 0.00) AS avg_score,
        COALESCE(s.rating_count, 0) AS rating_count
    FROM player p
    LEFT JOIN v_player_rating_summary s
        ON s.player_id = p.player_id;

    -- 1) 업서트: 투표/수정
    IF p_action = 'upsert' THEN
        INSERT INTO player_grade (player_id, user_id, score, is_deleted)
        VALUES (p_player_id, p_user_id, p_score, FALSE)
        ON DUPLICATE KEY UPDATE
            score = VALUES(score),
            is_deleted = FALSE,
            updated_at = CURRENT_TIMESTAMP;
        SELECT ROW_COUNT() AS affected_rows;

    -- 2) 삭제(soft delete)
    ELSEIF p_action = 'delete' THEN
        UPDATE player_grade
        SET is_deleted = TRUE, updated_at = CURRENT_TIMESTAMP
        WHERE player_id = p_player_id AND user_id = p_user_id AND is_deleted = FALSE;
        SELECT ROW_COUNT() AS affected_rows;

    -- 3) 팀별 선수 리스트
    ELSEIF p_action = 'team_list' THEN
        SELECT player_id, name, avg_score, rating_count
        FROM v_player_with_rating
        WHERE team_id = p_team_id
        ORDER BY avg_score DESC, rating_count DESC, name ASC
        LIMIT p_limit OFFSET p_offset;

    -- 4) 특정 선수 상세
    ELSEIF p_action = 'player_detail' THEN
        SELECT *
        FROM v_player_with_rating
        WHERE player_id = p_player_id;

    -- 5) 전체 선수 평점 요약
    ELSEIF p_action = 'summary' THEN
        SELECT *
        FROM v_player_rating_summary
        ORDER BY avg_score DESC, rating_count DESC;
    END IF;
END $$

DELIMITER ;
