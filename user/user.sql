-- =====================================================
-- 기존 프로시저 정리
-- =====================================================
DROP PROCEDURE IF EXISTS user_signup;
DROP PROCEDURE IF EXISTS user_login_check;
DROP PROCEDURE IF EXISTS user_update_nickname;
DROP PROCEDURE IF EXISTS user_find_id_by_email;
DROP PROCEDURE IF EXISTS user_reset_password_by_login;
DROP PROCEDURE IF EXISTS user_soft_delete;

DROP PROCEDURE IF EXISTS user_block_add;
DROP PROCEDURE IF EXISTS user_block_cancel_by_id;
DROP PROCEDURE IF EXISTS user_block_show;

DROP PROCEDURE IF EXISTS mypage_posts_by_user;
DROP PROCEDURE IF EXISTS mypage_comments_by_user;

DROP PROCEDURE IF EXISTS diary_add;
DROP PROCEDURE IF EXISTS diary_delete;
DROP PROCEDURE IF EXISTS diary_list_by_user;

DROP PROCEDURE IF EXISTS user_point_get;
DROP PROCEDURE IF EXISTS user_point_logs;
DROP PROCEDURE IF EXISTS user_bookmarks;

DELIMITER //

-- =====================================================
-- 회원가입
-- =====================================================
CREATE PROCEDURE user_signup(
    IN p_team_id     INT,
    IN p_login_id    VARCHAR(50),
    IN p_login_pw    VARCHAR(255),
    IN p_email       VARCHAR(255),
    IN p_name        VARCHAR(50),
    IN p_nickname    VARCHAR(50),
    IN p_gender      ENUM('M','F'),
    IN p_birth_date  DATE
)
BEGIN
    INSERT INTO `user` (
        team_id, login_id, login_pw, email, name, nickname, gender, birth_date
    ) VALUES (
        p_team_id, p_login_id, p_login_pw, p_email, p_name, p_nickname, p_gender, p_birth_date
    );
    -- 새로 생성된 user_id 반환
    SELECT LAST_INSERT_ID() AS new_user_id;
END //

-- =====================================================
-- 로그인 (성공 여부 0/1)
-- =====================================================
CREATE PROCEDURE user_login_check(
    IN p_login_id VARCHAR(50),
    IN p_login_pw VARCHAR(255)
)
BEGIN
    SELECT COUNT(1) AS '로그인 성공'
      FROM `user`
     WHERE login_id = p_login_id
       AND login_pw = p_login_pw
       AND is_deleted = FALSE
       AND ( suspension_end < CURRENT_TIMESTAMP OR suspension_end IS NULL );		-- 정지 회원인지 판별
END //

-- =====================================================
-- 회원 정보 수정 (닉네임)
-- =====================================================
CREATE PROCEDURE user_update_nickname(
    IN p_user_id INT,
    IN p_new_nickname VARCHAR(50)
)
BEGIN
    UPDATE `user`
       SET nickname = p_new_nickname
     WHERE user_id = p_user_id;

    SELECT * FROM `user` WHERE user_id = p_user_id;
END //

-- =====================================================
-- 아이디 찾기 (이메일로)
-- =====================================================
CREATE PROCEDURE user_find_id_by_email(
    IN p_email VARCHAR(255)
)
BEGIN
    SELECT login_id AS user_login_id
      FROM `user`
     WHERE email = p_email
       AND is_deleted = FALSE;
END //

-- =====================================================
-- 비밀번호 초기화/변경 (로그인ID 기준)
-- =====================================================
CREATE PROCEDURE user_reset_password_by_login(
    IN p_login_id VARCHAR(50),
    IN p_new_pw   VARCHAR(255)
)
BEGIN
    UPDATE `user`
       SET login_pw = p_new_pw
     WHERE login_id = p_login_id
       AND is_deleted = FALSE;

    SELECT user_id, login_id, login_pw, email, updated_at
      FROM `user`
     WHERE login_id = p_login_id;
END //

-- =====================================================
-- 회원 탈퇴 (소프트 삭제)
-- =====================================================
CREATE PROCEDURE user_soft_delete(
    IN p_user_id INT
)
BEGIN
    UPDATE `user`
       SET is_deleted = TRUE
     WHERE user_id = p_user_id;

    SELECT user_id, is_deleted, updated_at
      FROM `user`
     WHERE user_id = p_user_id;
END //

-- =====================================================
-- 다른 회원 차단 (blocker -> blocked)
-- =====================================================
CREATE PROCEDURE user_block_add(
    IN p_blocker_id INT,
    IN p_blocked_id INT
)
BEGIN
    INSERT INTO user_block (blocker_id, blocked_id)
    VALUES (p_blocker_id, p_blocked_id)
    ON DUPLICATE KEY UPDATE is_deleted = FALSE;
		
	 CALL cancle_follow (p_blocker_id, p_blocked_id); -- 팔로워한 사람이면 언팔로우	
		
    SELECT block_id, blocker_id, blocked_id, is_deleted, created_at
      FROM user_block
     WHERE blocker_id = p_blocker_id AND blocked_id = p_blocked_id;
END //

-- =====================================================
-- 회원 차단 해제
-- =====================================================
CREATE PROCEDURE user_block_cancel_by_id(
    IN p_blocker_id INT,
    IN p_blocked_id INT
)
BEGIN
    UPDATE user_block
       SET is_deleted = TRUE
     WHERE blocker_id = p_blocker_id
	    AND blocked_id = p_blocked_id;

    SELECT block_id, is_deleted
      FROM user_block
     WHERE blocker_id = p_blocker_id
	    AND blocked_id = p_blocked_id;
END //


-- =====================================================
-- 차단 내역 조회
-- =====================================================

CREATE PROCEDURE user_block_show(IN p_blocker_id INT)
BEGIN
  SELECT
       `block_id`
     , `blocker_id`
     , `blocked_id` AS '차단한 회원'
     , `created_at`
     , `is_deleted`
  FROM `user_block`
  WHERE blocker_id = p_blocker_id
    AND is_deleted = FALSE
  ORDER BY created_at DESC
  LIMIT 20;
END //


-- =====================================================
-- 마이페이지 - 본인 게시글 조회
-- =====================================================
CREATE PROCEDURE mypage_posts_by_user(IN p_user_id INT)
BEGIN
  SELECT 
  			board_id AS '일반 게시글'
  		 , user_id
		 , title
		 , `text`
		 , created_at
		 , updated_at
		 , category_id
  FROM board
  WHERE user_id = p_user_id AND is_deleted = FALSE
  ORDER BY created_at DESC
  LIMIT 20;

  SELECT 
  			board_id AS '친구 찾기 게시글'
  		 , user_id
		 , title
		 , `text`
		 , created_at
		 , updated_at
		 , game_id
		 , team_id
		 , friend_city_id
		 , gender
		 , age
  FROM friend_board
  WHERE user_id = p_user_id AND is_deleted = FALSE
  ORDER BY created_at DESC
  LIMIT 20;
END;

-- =====================================================
-- 마이페이지 - 본인 댓글 조회
-- =====================================================
CREATE PROCEDURE mypage_comments_by_user(IN p_user_id INT)
BEGIN
  SELECT
      comment_id AS '일반 댓글',
      parent_comment_id, 
      user_id,
      board_id,
      `text`,
      created_at,
      updated_at
  FROM `comment`
  WHERE user_id = p_user_id
    AND is_deleted = FALSE
  ORDER BY created_at DESC
  LIMIT 20;

  SELECT
      comment_id AS '친구찾기 댓글',
      parent_comment_id,
      user_id,
      board_id,
      `text`,
      created_at,
      updated_at
  FROM friend_comment
  WHERE user_id = p_user_id
    AND is_deleted = FALSE
  ORDER BY created_at DESC
  LIMIT 20;
END //

-- =====================================================
-- 경기 관람 내역 다이어리 작성
-- =====================================================
CREATE PROCEDURE diary_add(
    IN p_user_id INT,
    IN p_game_id INT,
    IN p_text    TEXT
)
BEGIN
    INSERT INTO diary (`text`, user_id, game_id)
    VALUES (p_text, p_user_id, p_game_id);

    SELECT LAST_INSERT_ID() AS new_diary_id;
END //

-- =====================================================
-- 경기 관람 내역 다이어리 삭제 (소프트 삭제)
-- =====================================================
CREATE PROCEDURE diary_delete(
    IN p_diary_id INT
)
BEGIN
    UPDATE diary
       SET is_deleted = 1
     WHERE diary_id = p_diary_id;

    SELECT diary_id, is_deleted
      FROM diary
     WHERE diary_id = p_diary_id;
END //

-- =====================================================
-- 경기 관람 내역 다이어리 조회 (사용자 기준)
-- =====================================================
CREATE PROCEDURE diary_list_by_user(
    IN p_user_id INT
)
BEGIN
    SELECT *
      FROM diary
     WHERE user_id = p_user_id
       AND (is_deleted IS NULL OR is_deleted != 1)
     ORDER BY created_at DESC;
END //

-- =====================================================
-- 회원 포인트 조회
-- =====================================================
CREATE PROCEDURE user_point_get(
    IN p_user_id INT
)
BEGIN
    SELECT point
      FROM `user`
     WHERE user_id = p_user_id
       AND is_deleted = FALSE;
END //

-- =====================================================
-- 회원 포인트 이력 조회
-- =====================================================
CREATE PROCEDURE user_point_logs(
    IN p_user_id INT
)
BEGIN
    SELECT *
      FROM point_log
     WHERE user_id = p_user_id
     ORDER BY created_at DESC;
END //

-- =====================================================
-- 북마크 조회
-- =====================================================
CREATE PROCEDURE user_bookmarks(
    IN p_user_id INT
)
BEGIN
    SELECT *
      FROM bookmark
     WHERE user_id = p_user_id
       AND (is_deleted IS NULL OR is_deleted != 1)
     ORDER BY bookmark_id ASC;
END //

DELIMITER ;
