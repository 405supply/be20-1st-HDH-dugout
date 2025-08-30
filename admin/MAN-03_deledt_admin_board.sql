-- 공지사항 삭제
UPDATE user_ban
SET is_deleted = TRUE,
    updated_at = CURRENT_TIMESTAMP
WHERE ban_id = ? AND is_deleted = FALSE;