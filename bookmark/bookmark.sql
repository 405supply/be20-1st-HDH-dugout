-- 북마크 등록

DROP PROCEDURE IF EXISTS add_bookmark;
DELIMITER //
CREATE PROCEDURE add_bookmark(IN p_board_id INT, IN p_user_id INT)
BEGIN
  INSERT INTO `bookmark` (board_id, user_id, is_deleted, enrollment_time)
  VALUES (p_board_id, p_user_id, 0, NOW())
  ON DUPLICATE KEY UPDATE -- 삭제 상태였다면 복구, 아니라면 시간 최신화
    is_deleted = 0,
    enrollment_time = NOW();
END //
DELIMITER ;


-- 북마크 조회

DROP PROCEDURE IF EXISTS list_bookmarks;
DELIMITER //
CREATE PROCEDURE list_bookmarks(IN p_user_id INT)
BEGIN
  SELECT
      b.bookmark_id,
      bo.board_id,
      bo.title,
      bo.user_id   AS writer_id,
      bo.created_at,
      b.enrollment_time AS bookmarked_at
  FROM `bookmark` b
  JOIN `board`   bo ON b.board_id = bo.board_id
  WHERE b.user_id    = p_user_id
    AND b.is_deleted = 0
    AND bo.is_deleted = 0
  ORDER BY b.enrollment_time DESC;
END //
DELIMITER ;


-- 북마크 삭제

DROP PROCEDURE IF EXISTS remove_bookmark;
DELIMITER //
CREATE PROCEDURE remove_bookmark(IN p_board_id INT, IN p_user_id INT)
BEGIN
  UPDATE `bookmark`
     SET is_deleted = 1
   WHERE board_id   = p_board_id
     AND user_id    = p_user_id
     AND is_deleted = 0;

END //
DELIMITER ;