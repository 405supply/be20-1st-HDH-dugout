-- 공지사항 수정
UPDATE admin_board
SET title = '업데이트 내용 수정',
    TEXT = '업데이트 내용 수정입니다.',
    updated_at = CURRENT_TIMESTAMP
WHERE board_id = 6
  AND is_deleted = FALSE;