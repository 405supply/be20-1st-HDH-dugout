-- 전체 게시글 목록 조회 (최근 등록순 + 페이징 예시)
SELECT board_id
     , category_id
     , user_id
     , title
     , created_at
  FROM board
 WHERE is_deleted = 0
 ORDER BY created_at DESC
 LIMIT 20 OFFSET 0;   -- ← 1페이지(20건) 예시
 
-- 상세 조회 기능
SELECT
  fb.board_id, fb.user_id, u.nickname AS author_nickname,
  fb.title, LEFT(fb.`text`, 200) AS preview,
  fb.gender, fb.age,
  fb.game_id, g.`date` AS game_date,
  fb.team_id, t.`name` AS team_name,
  fb.friend_city_id, fc.`name` AS city_name,
  fb.created_at
FROM friend_board fb
JOIN `user` u            ON u.user_id = fb.user_id
LEFT JOIN game g         ON g.game_id = fb.game_id
LEFT JOIN team t         ON t.team_id = fb.team_id
LEFT JOIN friend_city fc ON fc.friend_city_id = fb.friend_city_id
WHERE fb.is_deleted = 0
  AND (fb.title LIKE '%주말%' OR fb.`text` LIKE '%주말%')
  AND fb.gender IS NULL                    
  AND fb.age BETWEEN 20 AND 35
  AND fb.friend_city_id = 4
ORDER BY fb.created_at DESC, fb.board_id DESC
LIMIT 20 OFFSET 0;
