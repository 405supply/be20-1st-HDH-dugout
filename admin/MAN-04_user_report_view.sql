-- 회원 신고 조회

SELECT *
FROM (
  /* 게시글 신고(일반+친구찾기 통합) */
  SELECT
      CASE WHEN br.board_id IS NOT NULL THEN 'BOARD' ELSE 'FRIEND_BOARD' END AS report_type,
      br.board_report_id AS report_id,
      br.created_at,
      br.is_handled,
      br.reason,
      br.user_id         AS reporter_id,
      ru.nickname        AS reporter_nickname,
      COALESCE(b.user_id, fb.user_id)          AS target_user_id,
      COALESCE(tu1.nickname, tu2.nickname)     AS target_nickname,
      COALESCE(b.board_id, fb.board_id)        AS target_id,
      COALESCE(b.title, fb.title)              AS target_title
  FROM board_report br
  JOIN `user` ru   ON ru.user_id = br.user_id
  LEFT JOIN board        b  ON b.board_id  = br.board_id
  LEFT JOIN `user`       tu1 ON tu1.user_id = b.user_id
  LEFT JOIN friend_board fb ON fb.board_id = br.friend_board_id
  LEFT JOIN `user`       tu2 ON tu2.user_id = fb.user_id

  UNION ALL

  /* 댓글 신고(일반+친구찾기 통합) */
  SELECT
      CASE WHEN cr.comment_id IS NOT NULL THEN 'COMMENT' ELSE 'FRIEND_COMMENT' END AS report_type,
      cr.comment_report_id AS report_id,
      cr.created_at,
      cr.is_handled,
      cr.reason,
      cr.user_id           AS reporter_id,
      ru.nickname          AS reporter_nickname,
      COALESCE(c.user_id, fc.user_id)          AS target_user_id,
      COALESCE(tu3.nickname, tu4.nickname)     AS target_nickname,
      COALESCE(c.comment_id, fc.comment_id)    AS target_id,
      LEFT(COALESCE(c.text, fc.text), 120)     AS target_title
  FROM comment_report cr
  JOIN `user` ru   ON ru.user_id = cr.user_id
  LEFT JOIN comment        c  ON c.comment_id  = cr.comment_id
  LEFT JOIN `user`         tu3 ON tu3.user_id  = c.user_id
  LEFT JOIN friend_comment fc ON fc.comment_id = cr.friend_comment_id
  LEFT JOIN `user`         tu4 ON tu4.user_id  = fc.user_id
) r
WHERE (@p_target_user_id IS NULL OR r.target_user_id = @p_target_user_id)
  AND (@p_reporter_id    IS NULL OR r.reporter_id    = @p_reporter_id)
  AND (@p_is_handled     IS NULL OR r.is_handled     = @p_is_handled)
  AND (@p_from IS NULL OR r.created_at >= @p_from)
  AND (@p_to   IS NULL OR r.created_at <  @p_to)
ORDER BY r.created_at DESC, r.report_id DESC;
