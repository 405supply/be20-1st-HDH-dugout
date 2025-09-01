-- 테스트 코드
-- ===========
CALL insert_comment(1, 1, "반갑다 새로운 테스트 댓글이다5트", NULL);

SELECT * FROM comment ORDER BY created_at LIMIT 10;

-- ======
CALL select_comment(1);

-- ======
CALL edit_comment(5, "안녕 수정된 댓글");

SELECT * FROM comment WHERE comment_id = 5;

-- ======
CALL recommend_comment(2, 3, "U");

SELECT * FROM comment_recommend;

-- ======
CALL report_comment(3, 5, "악성 댓글");

SELECT * FROM comment_report;

 