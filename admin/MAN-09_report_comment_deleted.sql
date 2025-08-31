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

  IF v_cnt + 1 >= 10 THEN
    UPDATE comment
       SET is_deleted = TRUE,
           updated_at = CURRENT_TIMESTAMP
     WHERE comment_id = NEW.comment_id
       AND is_deleted = FALSE;
  END IF;
END//

DELIMITER ;