-- 친구찾기 게시글 조회
SELECT
  fb.board_id, fb.user_id, u.nickname AS author_nickname,
  fb.title, LEFT(fb.`text`, 200) AS preview,
  fb.gender, fb.age,
  fb.game_id, g.`date` AS game_date,
  fb.team_id, t.`name` AS team_name,
  fb.friend_city_id, fc.`name` AS city_name,
  fb.created_at
FROM friend_board fb
JOIN `user` u           ON u.user_id = fb.user_id
LEFT JOIN game g        ON g.game_id = fb.game_id
LEFT JOIN team t        ON t.team_id = fb.team_id
LEFT JOIN friend_city fc ON fc.friend_city_id = fb.friend_city_id
WHERE fb.is_deleted = 0
  -- 키워드: '주말'
  AND (
        fb.title    LIKE '%주말%' OR
        fb.`text`   LIKE '%주말%' OR
        u.nickname  LIKE '%주말%'
      )
  -- 성별: 여 + 무관 허용
  AND fb.gender IN ('여', '무관')
  -- 나이: 20 ~ 35
  AND fb.age BETWEEN 20 AND 35
  -- 팀: team_id = 1
  AND fb.team_id = 1
  -- 지역: friend_city_id = 2
  AND fb.friend_city_id = 2
  -- 경기 날짜: 2025-08-20 <= date < 2025-08-22
  AND g.`date` >= '2025-08-20 00:00:00'
  AND g.`date`  < '2025-08-22 00:00:00'
ORDER BY fb.created_at DESC, fb.board_id DESC;