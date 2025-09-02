-- 게시판 기능 구현

-- 전체 게시글 목록 조회
DROP PROCEDURE if exists select_all_board;
DELIMITER //

CREATE PROCEDURE select_all_board()
BEGIN
	SELECT board_id
		  , category_id
		  , user_id
		  , title
		  , created_at
	  FROM board
	 WHERE is_deleted = 0
	ORDER BY created_at DESC;
END //
DELIMITER ;

-- 카테고리 별 게시글 목록 조회
DROP PROCEDURE if exists select_board_by_category;
DELIMITER //

CREATE PROCEDURE select_board_by_category(IN _category_id INT)
BEGIN
	SELECT board_id
		  , user_id
		  , title
		  , created_at
	  FROM board
	 WHERE category_id = _category_id
	 	AND is_deleted = 0
	ORDER BY created_at DESC;
END //
DELIMITER ;


-- 게시글 상세 조회
DROP PROCEDURE if exists select_board_specific;
DELIMITER //

CREATE PROCEDURE select_board_specific(IN _board_id INT)
BEGIN
	SELECT b.board_id
		  , b.category_id
		  , b.user_id
		  , b.title
		  , b.text
		  , b.created_at
		  , b.updated_at
		  , IFNULL(SUM(case when br.type = 'U' then 1 ELSE 0 END), 0) AS upvote
		  , IFNULL(SUM(case when br.type = 'D' then 1 ELSE 0 END), 0) AS downvote
	  FROM board b
	  LEFT JOIN board_recommend br
	  ON b.board_id = br.board_id
	 WHERE b.board_id = _board_id
	 	AND b.is_deleted = 0
	 GROUP BY 
	 		 b.board_id
		  , b.category_id
		  , b.user_id
		  , b.title
		  , b.text
		  , b.created_at
		  , b.updated_at;
END //
DELIMITER ;
	  
-- 게시글 신고
DROP PROCEDURE if exists report_board;
DELIMITER //
CREATE PROCEDURE report_board(IN _user_id INT, IN _board_id INT, IN _reason TEXT)
BEGIN
	INSERT INTO board_report (user_id, board_id, reason, created_at, is_handled)
	VALUES (_user_id, _board_id, _reason, NOW(), 0);
END //
DELIMITER ;	

-- 게시글 등록
DROP PROCEDURE if exists insert_board;
DELIMITER //
CREATE PROCEDURE insert_board(
	IN _category_id INT,
	IN _user_id INT, 
	IN _title VARCHAR(80),
	IN _text TEXT
	)
BEGIN
	INSERT INTO board(category_id, user_id, title, TEXT)
	VALUES (_category_id, _user_id, _title, _text);
END //
DELIMITER ;

-- 게시글 수정
DROP PROCEDURE if exists edit_board;
DELIMITER //
CREATE PROCEDURE edit_board(
	IN _title VARCHAR(80),
	IN _text TEXT,
	IN _board_id INT,
	IN _user_id INT
)
BEGIN
	UPDATE board
			 SET title = _title
	     , TEXT = _text
	     , updated_at = CURRENT_TIMESTAMP
	 WHERE board_id = _board_id
	 	AND user_id = _user_id
	 	AND is_deleted = 0;
END //
DELIMITER ;


-- 게시글 삭제
DROP PROCEDURE if exists delete_board;
DELIMITER //
CREATE PROCEDURE delete_board(
	IN _board_id INT
)
BEGIN
	UPDATE board
	SET is_deleted = TRUE
	WHERE board_id = _board_id;
END //
delimiter ;
	
-- 게시글 추천 비추천
DROP PROCEDURE if exists recommend_board;
DELIMITER //
CREATE PROCEDURE recommend_board(
	IN _user_id INT,
	IN _board_id INT,
	IN _type ENUM('U', 'D')
)
BEGIN
	INSERT INTO board_recommend (user_id , board_id, TYPE)
	VALUES (_user_id, _board_id, _type);
END //
DELIMITER ;

-- hot 게시판
DROP PROCEDURE if exists select_popular_board;
DELIMITER //
CREATE PROCEDURE select_popular_board()
BEGIN
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
END //
DELIMITER ;

