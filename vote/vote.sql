
DELIMITER $$

-- Safety: drop if re-running
DROP PROCEDURE IF EXISTS CheckBaseCounts $$
DROP PROCEDURE IF EXISTS CastVote $$
DROP PROCEDURE IF EXISTS GetGameVoteSnapshot $$
DROP PROCEDURE IF EXISTS GetGameVoteResult $$
DROP PROCEDURE IF EXISTS GetHistoricalVoteResults $$
DROP PROCEDURE IF EXISTS GetInvalidVotes $$

-- -----------------------------------------------------------------------------
-- 1) CheckBaseCounts : 주요 테이블 (stadium, team, user, game, vote)의 현재 행(row) 수를 한번에 조회
-- 목적: DB 초기 구성 상태와 데이터 적재 현황을 빠르게 점검
-- -----------------------------------------------------------------------------
CREATE PROCEDURE CheckBaseCounts()
BEGIN
    SELECT 'stadium' AS tbl, COUNT(*) AS cnt FROM stadium
    UNION ALL SELECT 'team', COUNT(*) FROM team
    UNION ALL SELECT 'user', COUNT(*) FROM `user`
    UNION ALL SELECT 'game', COUNT(*) FROM game
    UNION ALL SELECT 'vote', COUNT(*) FROM vote;
END $$

-- -----------------------------------------------------------------------------
-- 2) CastVote : 특정 유저가 특정 경기에서 팀을 선택해 투표
--    - 경기 시작 전 (NOW() <g.date)에만 허용
--    -  (user_id, game_id)를 UNIQUE 키로 정의 -> ON DUPLICATE KEY UPDATE를 통해 기존 투표는 수정
-- -----------------------------------------------------------------------------
CREATE PROCEDURE CastVote(
  IN  p_user_id INT,
  IN  p_game_id INT,
  IN  p_team_id INT,
  OUT p_rows_affected INT
)
BEGIN
  -- 경기 시작 전 + 해당 경기 참가 팀(홈/원정)만 허용
  INSERT INTO vote (user_id, game_id, team_id, `date`)
  SELECT p_user_id, p_game_id, p_team_id, NOW()
  FROM game g
  WHERE g.game_id = p_game_id
    AND NOW() < g.`date`
    AND p_team_id IN (g.home_team_id, g.away_team_id)   -- ← 추가된 검증
  ON DUPLICATE KEY UPDATE
    team_id = VALUES(team_id),
    `date`  = NOW();

  SET p_rows_affected = ROW_COUNT();
END $$

-- -----------------------------------------------------------------------------
-- 3) GetGameVoteSnapshot : 지정 경기의 현재 시점 투표 수를 팀별 합계로 조회
-- 단순 집계(퍼센트 계산 없음)
-- -----------------------------------------------------------------------------
CREATE PROCEDURE GetGameVoteSnapshot(
    IN p_game_id INT
)
BEGIN
    SELECT
        t.team_id,
        t.name AS team_name,
        COUNT(v.vote_id) AS votes
    FROM game g
    JOIN team t ON t.team_id IN (g.home_team_id, g.away_team_id)
    LEFT JOIN vote v
           ON v.game_id = g.game_id
          AND v.team_id = t.team_id
    WHERE g.game_id = p_game_id
    GROUP BY t.team_id, t.name
    ORDER BY votes DESC, team_name;
END $$

-- -----------------------------------------------------------------------------
-- 4) GetGameVoteResult : 특정 경기의 최종 투표 결과 (마감 기준, 즉 v.date <g.date조건 적용)
-- 결과 항목 : 팀 별 표 수 + 득표율(pct)
-- -----------------------------------------------------------------------------
CREATE PROCEDURE GetGameVoteResult(
    IN p_game_id INT
)
BEGIN
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
END $$

-- -----------------------------------------------------------------------------
-- 5) GetHistoricalVoteResults : 전체 경기 또는 특정 경기의 투표 결과 이력 조회
-- 조건: 경기 마감 이전 투표만 반영
-- p_game_id  -> NULL이면 전체, 값 있으면 해당 경기만
-- p_limit -> NULL 또는 <=0 이면 전체, 값 있으면 지정 수만큼 제한
-- -----------------------------------------------------------------------------
CREATE PROCEDURE GetHistoricalVoteResults(
    IN p_game_id  INT,   -- NULL to include all games
    IN p_limit    INT    -- NULL or <=0 = no limit
)
BEGIN
    IF p_limit IS NULL OR p_limit <= 0 THEN

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
            JOIN team ht   ON ht.team_id = g.home_team_id
            JOIN team at   ON at.team_id = g.away_team_id
            LEFT JOIN vote v
                   ON v.game_id = g.game_id
                  AND v.`date`  < g.`date`
            WHERE p_game_id IS NULL OR g.game_id = p_game_id
            GROUP BY g.game_id, g.`date`, s.name, ht.name, at.name
        ) AS x
        ORDER BY x.start_time DESC;

    ELSE

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
            JOIN team ht   ON ht.team_id = g.home_team_id
            JOIN team at   ON at.team_id = g.away_team_id
            LEFT JOIN vote v
                   ON v.game_id = g.game_id
                  AND v.`date`  < g.`date`
            WHERE p_game_id IS NULL OR g.game_id = p_game_id
            GROUP BY g.game_id, g.`date`, s.name, ht.name, at.name
        ) AS x
        ORDER BY x.start_time DESC
        LIMIT p_limit;

    END IF;
END $$
-- -----------------------------------------------------------------------------
-- 6) GetInvalidVotes : 경기 시작 이후 (v.date >= g.date)에 발생한 무효 투표 수를 경기별 합계로 조회
-- 운영상 투표 관리 품질 점검, 사후 감사용 지표 확보
-- -----------------------------------------------------------------------------
CREATE PROCEDURE GetInvalidVotes(
    IN p_game_id INT  -- NULL to include all games
)
BEGIN
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

