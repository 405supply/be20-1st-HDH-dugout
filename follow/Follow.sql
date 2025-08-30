-- 팔로우 기능 구현

-- 팔로우하기
DELIMITER //

CREATE FUNCTION add_follow(following INT, followed INT)
RETURNS INT
DETERMINISTIC
BEGIN
	INSERT INTO follow (following_id, followed_id) VALUES (following, followed);
END //

DELIMITER ;     

-- 테스트 코드
add_follow(2, 5);


-- 팔로우 취소하기
DELIMITER //

CREATE FUNCTION cancle_follow(following INT, followed INT)
RETURNS INT
DETERMINISTIC
BEGIN
	UPDATE follow SET is_deleted = TRUE
	WHERE following_id = following AND followed_id = followed;
END //

DELIMITER ;

-- 테스트 코드
cancle_follow(2, 5);


-- 내가 팔로우 하고 있는 유저들의 id 및 팔로우 시간 조회
DELIMITER //

CREATE FUNCTION select_my_followed(user_id INT)
RETURN INT
DETERMINISTIC
BEGIN
	SELECT followed_id, created_at FROM follow
	WHERE following_id = user_id AND is_deleted = FALSE;
END //

DELIMITER ;

select_my_followed(7);


-- 나를 팔로우 하고 있는 유저들의 id 및 팔로우 시간 조회
SELECT following_id, created_at FROM follow
WHERE followed_id = '찾고자하는아이디' AND is_deleted = FALSE;

-- 내가 팔로우 하고 있는 유저의 게시글 조회
SELECT board_id, category_id, user_id, title, text, created_at, updated_at
WHERE user_id = '찾고자하는아이디' AND is_deleted = FALSE;
