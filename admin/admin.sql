-- 관리자 기능 구현

-- 공지사항 등록
DELIMITER //

DROP PROCEDURE IF EXISTS admin_board_create //

CREATE PROCEDURE admin_board_create(
  IN p_user_id INT,
  IN p_title   VARCHAR(50),
  IN p_text    TEXT
)
BEGIN
  IF EXISTS (SELECT 1 FROM admin WHERE user_id = p_user_id AND is_deleted = FALSE) THEN
    INSERT INTO admin_board (user_id, title, `text`)
    VALUES (p_user_id, p_title, p_text);

    -- 방금 등록한 공지 반환
    SELECT * FROM admin_board WHERE board_id = LAST_INSERT_ID();
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '관리자 계정이 없거나 삭제 상태입니다.';
  END IF;
END //

DELIMITER ;


-- 공지사항 수정
DELIMITER //

DROP PROCEDURE IF EXISTS admin_board_update//
CREATE PROCEDURE admin_board_update(
  IN p_board_id INT,
  IN p_new_title VARCHAR(50),
  IN p_new_text TEXT
)
BEGIN
  UPDATE admin_board
     SET title      = p_new_title,
         `text`     = p_new_text,
         updated_at = CURRENT_TIMESTAMP
   WHERE board_id   = p_board_id
     AND is_deleted = FALSE;

  IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = '대상 공지가 없거나 이미 삭제되었습니다.';
  END IF;

  -- 변경 결과 반환
  SELECT * FROM admin_board WHERE board_id = p_board_id;
END//

DELIMITER ;


-- 공지사항 삭제
DELIMITER //

DROP PROCEDURE IF EXISTS admin_board_delete//
CREATE PROCEDURE admin_board_delete(IN p_board_id INT)
BEGIN
  UPDATE admin_board
     SET is_deleted = TRUE,
         updated_at = CURRENT_TIMESTAMP
   WHERE board_id = p_board_id
     AND is_deleted = FALSE;

  IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = '대상 공지가 없거나 이미 삭제되었습니다.';
  END IF;

  -- 결과 확인용
  SELECT * FROM admin_board WHERE board_id = p_board_id;
END//

DELIMITER ;


-- 회원 신고 조회
DELIMITER //

DROP PROCEDURE IF EXISTS get_user_reports//
CREATE PROCEDURE get_user_reports(
    IN p_target_user_id INT,         -- 피신고자(작성자) ID (NULL 허용)
    IN p_reporter_id    INT,         -- 신고자 ID (NULL 허용)
    IN p_is_handled     TINYINT,     -- 처리여부 0/1 (NULL 허용)
    IN p_from           DATETIME,    -- 조회 시작일시 (NULL 허용)
    IN p_to             DATETIME,    -- 조회 종료일시 (NULL 허용, 미만 비교)
    IN p_limit          INT,         -- 페이지 크기
    IN p_offset         INT          -- 시작 위치
)
BEGIN
  SELECT *
  FROM (
    /* 게시글 신고(일반+친구찾기 통합) */
    SELECT
        CASE WHEN br.board_id IS NOT NULL THEN 'BOARD' ELSE 'FRIEND_BOARD' END AS report_type,
        br.board_report_id AS report_id,
        br.created_at,
        br.is_handled,
        br.reason,
        br.user_id                               AS reporter_id,
        ru.nickname                              AS reporter_nickname,
        COALESCE(b.user_id, fb.user_id)          AS target_user_id,
        COALESCE(tu1.nickname, tu2.nickname)     AS target_nickname,
        COALESCE(b.board_id, fb.board_id)        AS target_id,
        COALESCE(b.title, fb.title)              AS target_title
    FROM board_report br
    JOIN `user` ru            ON ru.user_id = br.user_id
    LEFT JOIN board        b  ON b.board_id  = br.board_id
    LEFT JOIN `user`       tu1 ON tu1.user_id = b.user_id
    LEFT JOIN friend_board fb ON fb.board_id  = br.friend_board_id
    LEFT JOIN `user`       tu2 ON tu2.user_id = fb.user_id

    UNION ALL

    /* 댓글 신고(일반+친구찾기 통합) */
    SELECT
        CASE WHEN cr.comment_id IS NOT NULL THEN 'COMMENT' ELSE 'FRIEND_COMMENT' END AS report_type,
        cr.comment_report_id AS report_id,
        cr.created_at,
        cr.is_handled,
        cr.reason,
        cr.user_id                               AS reporter_id,
        ru.nickname                              AS reporter_nickname,
        COALESCE(c.user_id, fc.user_id)          AS target_user_id,
        COALESCE(tu3.nickname, tu4.nickname)     AS target_nickname,
        COALESCE(c.comment_id, fc.comment_id)    AS target_id,
        LEFT(COALESCE(c.text, fc.text), 120)     AS target_title
    FROM comment_report cr
    JOIN `user` ru            ON ru.user_id = cr.user_id
    LEFT JOIN comment        c  ON c.comment_id  = cr.comment_id
    LEFT JOIN `user`         tu3 ON tu3.user_id  = c.user_id
    LEFT JOIN friend_comment fc ON fc.comment_id = cr.friend_comment_id
    LEFT JOIN `user`         tu4 ON tu4.user_id  = fc.user_id
  ) r
  WHERE (p_target_user_id IS NULL OR r.target_user_id = p_target_user_id)
    AND (p_reporter_id    IS NULL OR r.reporter_id    = p_reporter_id)
    AND (p_is_handled     IS NULL OR r.is_handled     = p_is_handled)
    AND (p_from IS NULL OR r.created_at >= p_from)
    AND (p_to   IS NULL OR r.created_at <  p_to)
  ORDER BY r.created_at DESC, r.report_id DESC
  LIMIT p_limit OFFSET p_offset;
END//

DELIMITER ;


-- 회원 정지 기능
-- N일 정지 (예: 3일)
DELIMITER //

DROP PROCEDURE IF EXISTS suspend_user_for_days//
CREATE PROCEDURE suspend_user_for_days(
    IN p_user_id INT,
    IN p_days    INT
)
BEGIN
    UPDATE `user`
       SET suspension_end = DATE_ADD(NOW(), INTERVAL p_days DAY)
     WHERE user_id = p_user_id
       AND is_deleted = 0;

    -- 결과 확인
    SELECT user_id, nickname, suspension_end
      FROM `user`
     WHERE user_id = p_user_id;
END//
 
-- 특정 일시까지 정지
DROP PROCEDURE IF EXISTS suspend_user_until//
CREATE PROCEDURE suspend_user_until(
    IN p_user_id INT,
    IN p_until   DATETIME
)
BEGIN
    UPDATE `user`
       SET suspension_end = p_until
     WHERE user_id = p_user_id
       AND is_deleted = 0;

    -- 결과 확인
    SELECT user_id, nickname, suspension_end
      FROM `user`
     WHERE user_id = p_user_id;
END//

DELIMITER ;


-- 회원 정지 해제
DELIMITER //

DROP PROCEDURE IF EXISTS unsuspend_user//
CREATE PROCEDURE unsuspend_user(
    IN p_user_id INT
)
BEGIN
    UPDATE `user`
       SET suspension_end = NULL
     WHERE user_id = p_user_id
       AND is_deleted = 0;

    -- 반영 결과 확인
    SELECT user_id, nickname, suspension_end
      FROM `user`
     WHERE user_id = p_user_id;
END//

DELIMITER ;


-- 정지된 회원 조회
DELIMITER //

DROP PROCEDURE IF EXISTS list_suspended_users//
CREATE PROCEDURE list_suspended_users()
BEGIN
    SELECT user_id, nickname, suspension_end
      FROM `user`
     WHERE is_deleted = 0
       AND suspension_end IS NOT NULL
       AND suspension_end > NOW()
     ORDER BY suspension_end ASC;
END//

DELIMITER ;


-- 게시글 15회 이상 신고 누적시 자동 삭제
DROP TRIGGER IF EXISTS trg_board_report_ai;

DELIMITER //

CREATE TRIGGER trg_board_report_ai
AFTER INSERT ON board_report
FOR EACH ROW
BEGIN
  DECLARE v_cnt INT;

  SELECT COUNT(*)
    INTO v_cnt
  FROM board_report
  WHERE board_id = NEW.board_id;

  IF v_cnt >= 15 THEN
    UPDATE board
       SET is_deleted = TRUE,
           updated_at = CURRENT_TIMESTAMP
     WHERE board_id = NEW.board_id
       AND is_deleted = FALSE;
  END IF;
END//

DELIMITER ;


-- 댓글 10회이상 신고 누적시 자동 삭제
DROP TRIGGER IF EXISTS trg_comment_report_ai;

DELIMITER //

CREATE TRIGGER trg_comment_report_ai
AFTER INSERT ON comment_report
FOR EACH ROW
BEGIN
  DECLARE v_cnt INT;

  SELECT COUNT(*) INTO v_cnt
  FROM comment_report
  WHERE comment_id = NEW.comment_id;

  IF v_cnt >= 10 THEN
    UPDATE comment
       SET is_deleted = TRUE,
           updated_at = CURRENT_TIMESTAMP
     WHERE comment_id = NEW.comment_id
       AND is_deleted = FALSE;
  END IF;
END//

DELIMITER ;