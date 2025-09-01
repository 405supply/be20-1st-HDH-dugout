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
	SELECT comment_id, parent_comment_id, user_id, TEXT, created_at, updated_at
	FROM comment
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