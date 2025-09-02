-- 팔로우 추가 테스트
-- 팔로우하기
DROP PROCEDURE if EXISTS add_follow;
DELIMITER //

CREATE PROCEDURE add_follow(IN following INT, IN followed INT)
BEGIN
	INSERT INTO follow (following_id, followed_id) VALUES (following, followed);
END //

DELIMITER ;     

SELECT * FROM `follow`;
CALL add_follow(1, 2); -- 1번 유저가 2번 유저 팔로우
CALL user_point_logs(2);
CALL add_follow(1, 3); -- 1번 유저가 3번 유저 팔로우
CALL user_point_logs(3);


-- 팔로우 취소 테스트
-- 팔로우 취소하기
DROP PROCEDURE if EXISTS cancle_follow;
DELIMITER //

CREATE PROCEDURE cancle_follow(IN following INT,IN followed INT)
BEGIN
	UPDATE follow SET is_deleted = TRUE
	WHERE following_id = following AND followed_id = followed;
END //

DELIMITER ;

SELECT * FROM `user`;
CALL cancle_follow(1, 2); -- 1번 유저가 2번 유저 팔로우
CALL user_point_logs(2);
CALL cancle_follow(1, 3); -- 1번 유저가 3번 유저 팔로우
CALL user_point_logs(3);