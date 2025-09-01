-- 게시글 등록 시 포인트 증가 및 로그 기록 트리거

DELIMITER //

DROP TRIGGER IF EXISTS trg_board_create_points //
CREATE TRIGGER trg_board_create_points
AFTER INSERT ON `board`
FOR EACH ROW
BEGIN
  -- 새로 생성된 글이 삭제 상태가 아닐 때만 포인트 지급
  IF NEW.is_deleted = 0 THEN
    UPDATE `user`
       SET `POINT` = `POINT` + 10
     WHERE user_id = NEW.user_id;

    INSERT INTO `point_log`(user_id, `type`, `action`, fluctuation, created_at)
    VALUES (NEW.user_id, 'post', 'insert', 10, NOW());
  END IF;
END //
//
DELIMITER ;


-- 게시글 삭제 시 포인트 차감 및 로그 기록 트리거

DELIMITER //

DROP TRIGGER IF EXISTS trg_board_delete_points //
CREATE TRIGGER trg_board_delete_points
AFTER UPDATE ON `board`
FOR EACH ROW
BEGIN
  -- is_deleted가 0 -> 1 로 바뀌는 순간에만 실행 (중복 차감 방지)
  IF OLD.is_deleted = 0 AND NEW.is_deleted = 1 THEN
    UPDATE `user`
       SET `POINT` = `POINT` - 10
     WHERE user_id = NEW.user_id;

    INSERT INTO `point_log`(user_id, `type`, `action`, fluctuation, created_at)
    VALUES (NEW.user_id, 'post', 'delete', -10, NOW());
  END IF;
END //

DELIMITER ;


-- 댓글 작성 시 포인트 증가 및 로그 기록 트리거

DELIMITER //

DROP TRIGGER IF EXISTS trg_comment_create_points //
CREATE TRIGGER trg_comment_create_points
AFTER INSERT ON `comment`
FOR EACH ROW
BEGIN
  -- 새로 생성된 댓글이 삭제 상태가 아닐 때만 지급(테이블에 is_deleted가 있다면)
  IF COALESCE(NEW.is_deleted, 0) = 0 THEN
    UPDATE `user`
       SET `POINT` = `POINT` + 5
     WHERE user_id = NEW.user_id;

    INSERT INTO `point_log`(user_id, `type`, `action`, fluctuation, created_at)
    VALUES (NEW.user_id, 'comment', 'insert', 5, NOW());
  END IF;
END //

DELIMITER ;


-- 댓글 삭제 시 포인트 차감 및 로그 기록 트리거

DELIMITER //

DROP TRIGGER IF EXISTS trg_comment_delete_points //
CREATE TRIGGER trg_comment_delete_points
AFTER UPDATE ON `comment`
FOR EACH ROW
BEGIN
  IF OLD.is_deleted = 0 AND NEW.is_deleted = 1 THEN
    UPDATE `user`
       SET `POINT` = `POINT` - 5
     WHERE user_id = NEW.user_id;

    INSERT INTO `point_log`(user_id, `type`, `action`, fluctuation, created_at)
    VALUES (NEW.user_id, 'comment', 'delete', -5, NOW());
  END IF;
END //

DELIMITER ;


-- 팔로우 추가 시 포인트 증가 및 로그 기록 트리거
DELIMITER //

DROP TRIGGER IF EXISTS trg_follow_points //
CREATE TRIGGER trg_follow_points
AFTER INSERT ON `follow`
FOR EACH ROW
BEGIN
  -- 새로 생성된 팔로우가 삭제 상태가 아닐 때만 지급
  IF COALESCE(NEW.is_deleted, 0) = 0 THEN
    UPDATE `user`
       SET `POINT` = `POINT` + 10
     WHERE user_id = NEW.followed_id;

    INSERT INTO `point_log`(user_id, `type`, `action`, fluctuation, created_at)
    VALUES (NEW.followed_id, 'follow', 'insert', 10, NOW());
  END IF;
END //

DELIMITER ;

-- 팔로우 해제 시 포인트 감소 및 로그 기록 트리거
DELIMITER //

DROP TRIGGER IF EXISTS trg_unfollow_points //
CREATE TRIGGER trg_unfollow_points
AFTER UPDATE ON `follow`
FOR EACH ROW
BEGIN
  IF OLD.is_deleted = 0 AND NEW.is_deleted = 1 THEN
    UPDATE `user`
       SET `POINT` = `POINT` - 10
     WHERE user_id = NEW.followed_id;

    INSERT INTO `point_log`(user_id, `type`, `action`, fluctuation, created_at)
    VALUES (NEW.followed_id, 'follow', 'delete', -10, NOW());
  END IF;
END //

DELIMITER ;