-- 공지사항 등록
INSERT INTO admin_board (user_id, title, text)
SELECT 1, '업데이트 안내', '업데이트를 시작합니다.'
FROM DUAL
WHERE EXISTS (
  SELECT 2 FROM admin
  WHERE user_id = 1 AND is_deleted = FALSE
);