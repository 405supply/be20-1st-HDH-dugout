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

  IF v_cnt + 1 >= 15 THEN
    UPDATE board
       SET is_deleted = TRUE,
           updated_at = CURRENT_TIMESTAMP
     WHERE board_id = NEW.board_id
       AND is_deleted = FALSE;
  END IF;
END//

DELIMITER ;