-- 게시판 기능 구현

-- 전체 게시글 목록 조회
SELECT board_id
	  , category_id
	  , user_id
	  , title
	  , created_at
  FROM board
 WHERE is_deleted = 0
ORDER BY = created_at DESC;

-- 카테고리 별 게시글 목록 조회
SELECT board_id
	  , user_id
	  , title
	  , created_at
  FROM board
 WHERE category_id = 4
 	AND is_deleted = 0
ORDER BY created_at DESC;

-- 게시글 상세 조회
SELECT board_id
	  , category_id
	  , user_id
	  , title
	  , text
	  , created_at
	  , updated_at
  FROM board
 WHERE board_id = 1
 	AND is_deleted = 0;
	  
-- 게시글 신고
INSERT INTO board_report (user_id, board_id, reason, created_at, is_handled)
VALUES (17, 5, NULL, NOW(), 0);

-- 게시글 등록
INSERT INTO board(category_id, user_id, title, TEXT)
VALUES (1, 23, '게시글 제목입니다', '제목이 곧 내용');

-- 게시글 수정
UPDATE board
		 SET title = '게시글 수정합니다'
     , TEXT = '제목이 곧 내용'
     , updated_at = CURRENT_TIMESTAMP
 WHERE board_id = 4
 	AND user_id = 17
 	AND is_deleted = 0;

-- 게시글 삭제
START TRANSACTION

UPDATE board
SET is_deleted = TRUE
WHERE board_id = 5
AND user_id = 17

UPDATE user
SET POINT  = POINT -10
WHERE user_id = 17

INSERT INTO point_log(user_id, TYPE, ACTION, fluctuation, created_at)
VALUES (17, 'post', 'delete', -10, NOW());

-- 게시글 추천 비추천
INSERT INTO board_recommend (user_id , board_id, TYPE)
VALUES (17, 5, 'U');
INSERT INTO board_recommend (user_id , board_id, TYPE)
VALUES (17, 5, 'D');

-- hot 게시판
SELECT b.board_id,
       b.title,
       b.user_id,
       SUM(CASE WHEN br.type = 'U' THEN 1
                WHEN br.type = 'D' THEN -1
                ELSE 0 END) AS score,
       COUNT(CASE WHEN br.type = 'U' THEN 1 END) AS up_count,
       COUNT(CASE WHEN br.type = 'D' THEN 1 END) AS down_count,
       b.created_at
FROM board b
LEFT JOIN board_recommend br ON b.board_id = br.board_id
WHERE b.is_deleted = FALSE
  AND b.created_at >= NOW() - INTERVAL 3 HOUR
GROUP BY b.board_id, b.title, b.user_id, b.created_at
HAVING score > 0
ORDER BY score DESC, up_count DESC, b.created_at DESC
LIMIT 10;

