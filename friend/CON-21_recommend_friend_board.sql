-- 친구 추천기능
SELECT
  r.board_id,
  r.candidate_user_id,
  r.author_nickname,
  r.title,
  r.preview,
  r.gender, r.age,
  r.team_id, r.team_name,
  r.friend_city_id, r.city_name,
  r.game_id, r.game_date,
  r.match_cnt,
  r.weight_score,
  r.created_at
FROM (
  SELECT
    fb.board_id,
    fb.user_id AS candidate_user_id,
    u.nickname AS author_nickname,
    fb.title,
    LEFT(fb.`text`, 200) AS preview,
    fb.gender,
    fb.age,
    fb.team_id,
    t.`name` AS team_name,
    fb.friend_city_id,
    fc.`name` AS city_name,
    fb.game_id,
    g.`date` AS game_date,
    fb.created_at,

    /* 일치 개수(5가지: 성별/나이/지역/팀/날짜) */
    (
      CASE WHEN (fb.gender = '여' OR fb.gender = '무관') THEN 1 ELSE 0 END
      + CASE WHEN (fb.age BETWEEN 25 AND 34) THEN 1 ELSE 0 END
      + CASE WHEN (fb.friend_city_id = 2) THEN 1 ELSE 0 END
      + CASE WHEN (fb.team_id = 1) THEN 1 ELSE 0 END
      + CASE
          WHEN g.`date` >= '2025-08-20 00:00:00'
           AND g.`date`  < '2025-08-22 00:00:00'
          THEN 1 ELSE 0
        END
    ) AS match_cnt,

    /* 가중치 점수(예: 날짜×3, 팀×2, 지역×2, 성별×1, 나이×1) */
    (
      1 * CASE WHEN (fb.gender = '여' OR fb.gender = '무관') THEN 1 ELSE 0 END
      + 1 * CASE WHEN (fb.age BETWEEN 25 AND 34) THEN 1 ELSE 0 END
      + 2 * CASE WHEN (fb.friend_city_id = 2) THEN 1 ELSE 0 END
      + 2 * CASE WHEN (fb.team_id = 1) THEN 1 ELSE 0 END
      + 3 * CASE
              WHEN g.`date` >= '2025-08-20 00:00:00'
               AND g.`date`  < '2025-08-22 00:00:00'
              THEN 1 ELSE 0
            END
    ) AS weight_score

  FROM friend_board fb
  JOIN `user` u            ON u.user_id = fb.user_id
  LEFT JOIN game g         ON g.game_id = fb.game_id
  LEFT JOIN team t         ON t.team_id = fb.team_id
  LEFT JOIN friend_city fc ON fc.friend_city_id = fb.friend_city_id
  WHERE fb.is_deleted = 0
    AND fb.user_id <> 25  -- 본인 글 제외
) AS r
WHERE r.match_cnt > 0      -- 최소 한 항목이라도 일치하는 글만
ORDER BY r.match_cnt DESC, r.weight_score DESC, r.created_at DESC
LIMIT 1;