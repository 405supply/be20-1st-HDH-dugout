-- 북마크 기능 구현

-- 북마크 추가
INSERT INTO bookmark (board_id, user_id, is_deleted)
VALUES (27, 13, 0);

-- 북마크 조회
SELECT b.bookmark_id,
       bo.board_id,
       bo.title,
       bo.user_id   AS writer_id,
       bo.created_at,
       b.enrollment_time AS bookmarked_at
FROM bookmark b
JOIN board bo ON b.board_id = bo.board_id
WHERE b.user_id = 25
  AND b.is_deleted = 0
  AND bo.is_deleted = 0   -- 게시글이 삭제되지 않은 경우만
ORDER BY b.enrollment_time DESC;

-- 북마크 해제
UPDATE bookmark
SET is_deleted = 1
WHERE board_id = 27
  AND user_id = 13
  AND id_deleted = 0;