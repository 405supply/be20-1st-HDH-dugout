-- 댓글 기능 구현

-- 댓글 등록
DROP PROCEDURE if EXISTS insert_comment;

DELIMITER //
CREATE PROCEDURE insert_comment
(IN _user_id INT,
 IN _board_id INT,
 IN _text TEXT,
 IN _parent_comment_id INT
)
BEGIN
	INSERT INTO comment(user_id, board_id, text, parent_comment_id)
	VALUES(_user_id, _board_id, _text, _parent_comment_id);
END //
DELIMITER ;

-- 댓글 조회
DROP PROCEDURE if EXISTS select_comment;

DELIMITER //
CREATE PROCEDURE select_comment(IN _board_id INT)
BEGIN
	DROP VIEW if EXISTS upvote;
	CREATE VIEW upvote as
		SELECT COUNT(*) AS up, c.comment_id
		 FROM comment c
		 JOIN comment_recommend cr
		 ON c.comment_id = cr.comment_id
		 WHERE cr.type = 'U'
		 GROUP BY c.comment_id;
	
	DROP VIEW if EXISTS downvote;
	CREATE VIEW downvote as
		SELECT COUNT(*) AS down, c.comment_id
		 FROM comment c
		 JOIN comment_recommend cr
		 ON c.comment_id = cr.comment_id
		 WHERE cr.type = 'D'
		 GROUP BY c.comment_id;
	
	SELECT c.comment_id, c.parent_comment_id, c.user_id, c.TEXT, c.created_at, c.updated_at, ifnull(u.up, 0), ifnull(d.down, 0)
	FROM comment c
	left JOIN upvote u ON c.comment_id = u.comment_id
	left JOIN downvote d ON c.comment_id = d.comment_id
	WHERE board_id = _board_id;
END //
DELIMITER ;

-- 댓글 수정
DROP PROCEDURE if EXISTS edit_comment;

DELIMITER //
CREATE PROCEDURE edit_comment(IN _comment_id INT, IN _text TEXT)
BEGIN
	UPDATE comment
	SET TEXT = _text,
	updated_at = NOW()
	WHERE comment_id = _comment_id;
END //
DELIMITER ;

-- 댓글 추천
DROP PROCEDURE if EXISTS recommend_comment;

DELIMITER //
CREATE PROCEDURE recommend_comment(IN _user_id INT, IN _comment_id INT, IN _type ENUM('U', 'D'))
BEGIN
	INSERT INTO comment_recommend (user_id , comment_id, TYPE)
	VALUES (_user_id, _comment_id, _type);
END //
DELIMITER ;

-- 댓글 신고
DROP PROCEDURE if EXISTS report_comment;

DELIMITER //
CREATE PROCEDURE report_comment(IN _user_id INT, IN _comment_id INT, IN _reason TEXT)
BEGIN
	INSERT INTO comment_report (user_id, comment_id, reason)
	VALUES (_user_id, _comment_id, _reason);
END //
DELIMITER ;