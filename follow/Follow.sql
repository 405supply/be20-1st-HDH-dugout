-- 팔로우 기능 구현

-- 팔로우하기
DROP PROCEDURE if EXISTS add_follow;
DELIMITER //

CREATE PROCEDURE add_follow(IN following INT, IN followed INT)
BEGIN
	INSERT INTO follow (following_id, followed_id) VALUES (following, followed);
END //

DELIMITER ;     


-- 팔로우 취소하기
DROP PROCEDURE if EXISTS cancle_follow;
DELIMITER //

CREATE PROCEDURE cancle_follow(IN following INT,IN followed INT)
BEGIN
	UPDATE follow SET is_deleted = TRUE
	WHERE following_id = following AND followed_id = followed;
END //

DELIMITER ;


-- 내가 팔로우 하고 있는 유저들의 id 및 팔로우 시간 조회
DROP PROCEDURE if EXISTS select_my_following;
DELIMITER //

CREATE PROCEDURE select_my_following(IN user_id INT)
BEGIN
	SELECT followed_id, created_at FROM follow
	WHERE following_id = user_id AND is_deleted = FALSE;
END //

DELIMITER ;


-- 나를 팔로우 하고 있는 유저들의 id 및 팔로우 시간 조회
DROP PROCEDURE if EXISTS select_my_followed;
DELIMITER //

CREATE PROCEDURE select_my_followed(IN user_id INT)
BEGIN
	SELECT following_id, created_at FROM follow
	WHERE followed_id = user_id AND is_deleted = FALSE;
END //

DELIMITER ;


-- 내가 팔로우 하고 있는 유저들의 게시글 조회
DROP PROCEDURE if EXISTS select_following_user_board;
DELIMITER //

CREATE PROCEDURE select_following_user_board(IN user_id INT)
BEGIN
	SELECT b.board_id, b.category_id, b.user_id, b.title, b.text, b.created_at, b.updated_at
	FROM follow f
	JOIN board b ON f.followed_id = b.user_id
	WHERE f.following_id = user_id;
END //

DELIMITER ;


-- ---------------------
-- 테스트 코드

/*

CALL add_follow(1, 2); -- 1번 유저가 2번 유저 팔로우
CALL add_follow(1, 3); -- 1번 유저가 3번 유저 팔로우
CALL add_follow(3, 4); -- 3번 유저가 4번 유저 팔로우
CALL add_follow(4, 3); -- 4번 유저가 3번 유저 팔로우

SELECT * FROM follow; -- 팔로우 연결 관계 점검

CALL cancle_follow (1, 2); -- 1번 유저가 2번 유저 팔로우 취소

SELECT * FROM follow;

CALL select_my_following(3);
CALL select_my_followed(4);
CALL select_following_user_board(3);

*/
