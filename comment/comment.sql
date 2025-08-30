-- 댓글 기능 구현

-- 댓글 등록
INSERT INTO comment (user_id, text)
VALUES (1, '첫 번째 댓글 등록');

-- 대댓글 등록
INSERT INTO comment (user_id, text, parent_comment_id)
VALUES (2, '첫 번째 대댓글 등', 16);

-- 단어 필터링 기능

-- 댓글 포인트 기능
START TRANSACTION;

INSERT INTO comment (user_id, TEXT)
VALUES (13, '포인트 냠냠')

UPDATE user
SET POINT = POINT + 5
WHERE user_id = 13

INSERT INTO point_log (user_id, TYPE, ACTION, fluctuation, created_at)
VALUES (13, 'comment', 

-- 댓글 조회
SELECT comment_ref
     , a.comment_id
	  , a.text
	  , a.created_at
	  , b.nickname
	  , c.up_count
	  , c.down_count
  FROM (
    SELECT CONCAT(comment_id,"_0") AS comment_ref
    , oc.*
    FROM comment oc
    WHERE parent_comment_id IS NULL
    UNION ALL
    SELECT CONCAT(parent_comment_id,"_", comment_id) AS comment_ref
    , rc.*
    FROM comment rc
    WHERE parent_comment_id IS NOT NULL
       ) as a
  JOIN user b ON a.user_id = b.user_id
  JOIN (
        SELECT comment_id,
           SUM(CASE WHEN type = 'u' THEN 1 ELSE 0 END) AS up_count,
           SUM(CASE WHEN type = 'd' THEN 1 ELSE 0 END) AS down_count
        FROM comment_recommend
        GROUP BY comment_id
       ) c ON c.comment_id =  a.comment_id
-- WHERE a.comment_ref NOT LIKE '%_0'
ORDER BY CAST(SUBSTRING_INDEX(a.comment_ref, '_', 1) AS UNSIGNED)
,CAST(SUBSTRING_INDEX(a.comment_ref, '_', -1) AS UNSIGNED);player_comment

-- 댓글 수정
UPDATE comment
SET TEXT = '수정된 댓글 입니다.'
UPDATE AT = NOW()
WHERE comment_id = 2
  AND user_id = 24;

-- 댓글 삭제 (포인트 회수)
START TRANSACTION

UPDATE comment
SET is_deleted = TRUE
WHERE commet_id = 5
AND user_id = 17

UPDATE user
SET POINT  = POINT - 5
WHERE user_id = 17

INSERT INTO point_log(user_id, TYPE, ACTION, fluctuation, created_at)
VALUES (17, 'comment', 'delete', -5, NOW());

-- 댓글 추천
INSERT INTO comment_recommend (user_id , comment_id, TYPE)
VALUES (17, 5, 'U')
INSERT INTO comment_recommend (user_id , comment_id, TYPE)
VALUES (17, 5, 'D')

-- 댓글 신고
INSERT INTO comment_report (user_id, comment_id, reason, created_at, is_handled)
VALUES (17, 5, NULL, NOW(), 0)
