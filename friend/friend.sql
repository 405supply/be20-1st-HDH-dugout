-- 친구 기능 구현
-- 친구찾기 게시글 등록
DROP PROCEDURE IF EXISTS friend_board_insert;
DELIMITER //

CREATE PROCEDURE friend_board_insert(
    IN  p_user_id         INT,
    IN  p_game_id         INT,
    IN  p_team_id         INT,
    IN  p_friend_city_id  INT,
    IN  p_title           VARCHAR(50),
    IN  p_text            TEXT,
    IN  p_gender          CHAR(3),
    IN  p_age             INT,
    OUT o_board_id        INT
)
BEGIN
    INSERT INTO friend_board
        (user_id, game_id, team_id, friend_city_id, title, `text`, gender, age)
    VALUES
        (p_user_id, p_game_id, p_team_id, p_friend_city_id, p_title, p_text, p_gender, p_age);

    SET o_board_id = LAST_INSERT_ID();

    -- 방금 등록한 행 확인용
    SELECT *
      FROM friend_board
     WHERE board_id = o_board_id;
END //
DELIMITER ;


-- 친구찾기 게시글 수정
DROP PROCEDURE IF EXISTS friend_board_update;
DELIMITER //

CREATE PROCEDURE friend_board_update(
    IN p_board_id        INT,
    IN p_user_id         INT,
    IN p_title           VARCHAR(50),
    IN p_text            TEXT,
    IN p_gender          CHAR(3),   -- '남','여','무관' 권장
    IN p_age             INT,
    IN p_game_id         INT,
    IN p_team_id         INT,
    IN p_friend_city_id  INT
)
BEGIN
    -- 대상 존재/삭제 여부 확인
    IF (SELECT COUNT(*) FROM friend_board
        WHERE board_id = p_board_id AND user_id = p_user_id AND is_deleted = 0) = 0 THEN
        SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = '수정 대상이 없거나 삭제되었습니다.';
    END IF;

    -- 성별 값 검증(선택)
    IF p_gender IS NOT NULL AND p_gender NOT IN ('남','여','무관') THEN
        SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'gender는 남/여/무관 중 하나여야 합니다.';
    END IF;

    UPDATE friend_board
       SET title          = p_title,
           `text`         = p_text,
           gender         = p_gender,
           age            = p_age,
           game_id        = p_game_id,
           team_id        = p_team_id,
           friend_city_id = p_friend_city_id
     WHERE board_id = p_board_id
       AND user_id  = p_user_id
       AND is_deleted = 0;

    -- 결과 반환(갱신된 행)
    SELECT * FROM friend_board WHERE board_id = p_board_id;
END//
DELIMITER ;

-- 친구 찾기 게시글 삭제
DROP PROCEDURE IF EXISTS friend_board_soft_delete;
DELIMITER //

CREATE PROCEDURE friend_board_soft_delete(
    IN p_board_id INT,
    IN p_user_id  INT
)
BEGIN
    -- 대상 존재/미삭제 여부 확인
    IF (SELECT COUNT(*)
          FROM friend_board
         WHERE board_id = p_board_id
           AND user_id  = p_user_id
           AND is_deleted = 0) = 0 THEN
        SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = '삭제 대상이 없거나 이미 삭제되었습니다.';
    END IF;

    UPDATE friend_board
       SET is_deleted = 1
     WHERE board_id = p_board_id
       AND user_id  = p_user_id
       AND is_deleted = 0;

    -- 결과 반환(상태 확인)
    SELECT board_id, user_id, is_deleted, updated_at
      FROM friend_board
     WHERE board_id = p_board_id;
END//
DELIMITER ;

-- 친구 찾기 게시글 조회
/* 전체 게시글 목록 조회  */
DROP PROCEDURE IF EXISTS board_list_paged;
DELIMITER //

CREATE PROCEDURE board_list_paged(
    IN p_limit  INT,
    IN p_offset INT
)
BEGIN
    SELECT board_id
         , category_id
         , user_id
         , title
         , created_at
      FROM board
     WHERE is_deleted = 0
     ORDER BY created_at DESC
     LIMIT p_limit OFFSET p_offset;
END//
DELIMITER ;

/* 친구찾기 게시글 상세/검색 조회 (키워드/성별/나이/도시 + 페이지네이션) */
DROP PROCEDURE IF EXISTS friend_board_search;
DELIMITER //
CREATE PROCEDURE friend_board_search(
    IN p_keyword          VARCHAR(100),  -- 제목/내용/작성자 닉네임 키워드(부분일치)
    IN p_gender           CHAR(3),       -- 성별 정확히 필터('남','여','무관' 등). 필터 없으면 NULL
    IN p_only_null_gender TINYINT,       -- 성별이 NULL인 글만 보고 싶으면 1, 아니면 0
    IN p_min_age          INT,           -- 최소나이(없으면 NULL)
    IN p_max_age          INT,           -- 최대나이(없으면 NULL)
    IN p_friend_city_id   INT,           -- 도시 ID(없으면 NULL)
    IN p_limit            INT,
    IN p_offset           INT
)
BEGIN
    SELECT
      fb.board_id, fb.user_id, u.nickname AS author_nickname,
      fb.title, LEFT(fb.`text`, 200) AS preview,
      fb.gender, fb.age,
      fb.game_id, g.`date` AS game_date,
      fb.team_id, t.`name` AS team_name,
      fb.friend_city_id, fc.`name` AS city_name,
      fb.created_at
    FROM friend_board fb
    JOIN `user` u            ON u.user_id = fb.user_id
    LEFT JOIN game g         ON g.game_id = fb.game_id
    LEFT JOIN team t         ON t.team_id = fb.team_id
    LEFT JOIN friend_city fc ON fc.friend_city_id = fb.friend_city_id
    WHERE fb.is_deleted = 0
      AND (
            p_keyword IS NULL
         OR fb.title    LIKE CONCAT('%', p_keyword, '%')
         OR fb.`text`   LIKE CONCAT('%', p_keyword, '%')
         OR u.nickname  LIKE CONCAT('%', p_keyword, '%')
          )
      AND (
            (p_only_null_gender = 1 AND fb.gender IS NULL)
         OR (p_only_null_gender = 0 AND (p_gender IS NULL OR fb.gender = p_gender))
          )
      AND (p_min_age IS NULL OR fb.age >= p_min_age)
      AND (p_max_age IS NULL OR fb.age <= p_max_age)
      AND (p_friend_city_id IS NULL OR fb.friend_city_id = p_friend_city_id)
    ORDER BY fb.created_at DESC, fb.board_id DESC
    LIMIT p_limit OFFSET p_offset;
END//
DELIMITER ;


-- 친구찾기 게시글 댓글 등록
DROP PROCEDURE IF EXISTS friend_comment_create;
DELIMITER //

CREATE PROCEDURE friend_comment_create(
    IN p_parent_comment_id INT,   -- 대댓글이면 부모 댓글 ID, 아니면 NULL
    IN p_user_id           INT,   -- 작성자
    IN p_board_id          INT,   -- 대상 친구찾기 게시글
    IN p_text              TEXT   -- 내용
)
BEGIN
    INSERT INTO friend_comment (parent_comment_id, user_id, board_id, `text`)
    VALUES (p_parent_comment_id, p_user_id, p_board_id, p_text);

    /* 방금 등록한 행 반환 */
    SELECT *
      FROM friend_comment
     WHERE comment_id = LAST_INSERT_ID();
END//
DELIMITER ;


-- 친구찾기 댓글 수정: 본인 댓글이며 삭제되지 않은 경우만 수정 
DROP PROCEDURE IF EXISTS friend_comment_update;
DELIMITER //

CREATE PROCEDURE friend_comment_update(
    IN p_comment_id INT,
    IN p_user_id    INT,
    IN p_text       TEXT
)
BEGIN
    UPDATE friend_comment
       SET `text` = p_text,
           updated_at = CURRENT_TIMESTAMP
     WHERE comment_id = p_comment_id
       AND user_id    = p_user_id
       AND is_deleted = 0;

    /* 수정 대상이 없으면 에러 */
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No updatable comment (wrong id/user or already deleted).';
    END IF;

    /* 수정 결과 반환 */
    SELECT *
      FROM friend_comment
     WHERE comment_id = p_comment_id;
END//
DELIMITER ;


-- 친구찾기 댓글 삭제
DROP PROCEDURE IF EXISTS friend_comment_delete;
DELIMITER //

CREATE PROCEDURE friend_comment_delete(
    IN p_comment_id INT,
    IN p_user_id    INT
)
BEGIN
    UPDATE friend_comment
       SET is_deleted = 1,
           updated_at = CURRENT_TIMESTAMP
     WHERE comment_id = p_comment_id
       AND user_id    = p_user_id
       AND is_deleted = 0;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No deletable comment (wrong id/user or already deleted).';
    END IF;

    /* 삭제 결과 확인용 반환 */
    SELECT comment_id, user_id, is_deleted, updated_at
      FROM friend_comment
     WHERE comment_id = p_comment_id;
END//
DELIMITER ;


-- 친구 찾기 맞춤 게시글 조회
/* 친구 추천: 조건 일치도/가중치로 랭킹 */
DROP PROCEDURE IF EXISTS friend_board_recommend;
DELIMITER //

CREATE PROCEDURE friend_board_recommend(
    IN p_user_id    INT,         -- 본인(제외용)
    IN p_gender     CHAR(3),     -- '남'/'여'/'무관' 또는 'M'/'F'
    IN p_min_age    INT,         -- null 가능
    IN p_max_age    INT,         -- null 가능
    IN p_city_id    INT,         -- null 가능
    IN p_team_id    INT,         -- null 가능
    IN p_date_from  DATETIME,    -- null 가능
    IN p_date_to    DATETIME,    -- null 가능
    IN p_limit      INT          -- null이면 10
)
BEGIN
    DECLARE v_limit  INT  DEFAULT 10;
    DECLARE v_gpref  CHAR(3);

    SET v_limit = IFNULL(p_limit, 10);

    /* 성별 표준화: '여'|'F' -> 'F', '남'|'M' -> 'M', '무관' 유지 */
    SET v_gpref = CASE
        WHEN p_gender IN ('여','F') THEN 'F'
        WHEN p_gender IN ('남','M') THEN 'M'
        WHEN p_gender = '무관'      THEN '무관'
        ELSE NULL
    END;

    SELECT
      r.board_id,
      r.candidate_user_id,
      r.author_nickname,
      r.title,
      r.preview,
      r.gender, r.age,
      r.team_id, r.team_name,
      r.friend_city_id, r.city_name,
      r.game_id, r.game_date,
      r.match_cnt,
      r.weight_score,
      r.created_at
    FROM (
      SELECT
        fb.board_id,
        fb.user_id AS candidate_user_id,
        u.nickname AS author_nickname,
        fb.title,
        LEFT(fb.`text`, 200) AS preview,
        fb.gender,
        fb.age,
        fb.team_id,
        t.`name` AS team_name,
        fb.friend_city_id,
        fc.`name` AS city_name,
        fb.game_id,
        g.`date` AS game_date,
        fb.created_at,

        /* 5개 항목 일치 개수 */
        (
          /* 성별 */
          CASE
            WHEN v_gpref IS NULL THEN 0
            WHEN v_gpref = '무관' THEN 1
            WHEN v_gpref = 'F' THEN CASE WHEN fb.gender IN ('F','여','무관') THEN 1 ELSE 0 END
            WHEN v_gpref = 'M' THEN CASE WHEN fb.gender IN ('M','남','무관') THEN 1 ELSE 0 END
            ELSE 0
          END
          +
          /* 나이 */
          CASE
            WHEN p_min_age IS NOT NULL AND p_max_age IS NOT NULL
                 AND fb.age BETWEEN p_min_age AND p_max_age THEN 1 ELSE 0 END
          +
          /* 지역 */
          CASE
            WHEN p_city_id IS NOT NULL AND fb.friend_city_id = p_city_id THEN 1 ELSE 0 END
          +
          /* 팀 */
          CASE
            WHEN p_team_id IS NOT NULL AND fb.team_id = p_team_id THEN 1 ELSE 0 END
          +
          /* 날짜 */
          CASE
            WHEN p_date_from IS NOT NULL AND p_date_to IS NOT NULL
                 AND g.`date` >= p_date_from AND g.`date` < p_date_to THEN 1 ELSE 0 END
        ) AS match_cnt,

        /* 가중치 점수: 날짜×3, 팀×2, 지역×2, 성별×1, 나이×1 */
        (
          /* 성별 */
          1 * (
            CASE
              WHEN v_gpref IS NULL THEN 0
              WHEN v_gpref = '무관' THEN 1
              WHEN v_gpref = 'F' THEN CASE WHEN fb.gender IN ('F','여','무관') THEN 1 ELSE 0 END
              WHEN v_gpref = 'M' THEN CASE WHEN fb.gender IN ('M','남','무관') THEN 1 ELSE 0 END
              ELSE 0
            END
          )
          +
          /* 나이 */
          1 * (CASE
                 WHEN p_min_age IS NOT NULL AND p_max_age IS NOT NULL
                      AND fb.age BETWEEN p_min_age AND p_max_age THEN 1 ELSE 0 END)
          +
          /* 지역 */
          2 * (CASE WHEN p_city_id IS NOT NULL AND fb.friend_city_id = p_city_id THEN 1 ELSE 0 END)
          +
          /* 팀 */
          2 * (CASE WHEN p_team_id IS NOT NULL AND fb.team_id = p_team_id THEN 1 ELSE 0 END)
          +
          /* 날짜 */
          3 * (CASE
                 WHEN p_date_from IS NOT NULL AND p_date_to IS NOT NULL
                      AND g.`date` >= p_date_from AND g.`date` < p_date_to THEN 1 ELSE 0 END)
        ) AS weight_score

      FROM friend_board fb
      JOIN `user` u            ON u.user_id = fb.user_id
      LEFT JOIN game g         ON g.game_id = fb.game_id
      LEFT JOIN team t         ON t.team_id = fb.team_id
      LEFT JOIN friend_city fc ON fc.friend_city_id = fb.friend_city_id
      WHERE fb.is_deleted = 0
        AND fb.user_id <> p_user_id
    ) AS r
    WHERE r.match_cnt > 0
    ORDER BY r.match_cnt DESC, r.weight_score DESC, r.created_at DESC
    LIMIT v_limit;
END//
DELIMITER ;