-- 팔로우 기능 구현

-- 팔로우하기
INSERT INTO follow (following_id, followed_id)
VALUES ('나의 id', '팔로우 대상의 id');


-- 팔로우 취소하기
UPDATE follow SET is_deleted = TRUE
WHERE following_id = '나의 id', '팔로우 대상의 id');


-- 내가 팔로우 하고 있는 유저들의 id 및 팔로우 시간 조회 
SELECT followed_id, created_at FROM follow
WHERE following_id = '찾고자하는아이디' AND is_deleted = FALSE;


-- 나를 팔로우 하고 있는 유저들의 id 및 팔로우 시간 조회
SELECT following_id, created_at FROM follow
WHERE followed_id = '찾고자하는아이디' AND is_deleted = FALSE;

-- 내가 팔로우 하고 있는 유저의 게시글 조회
SELECT board_id, category_id, user_id, title, text, created_at, updated_at
WHERE user_id = '찾고자하는아이디' AND is_deleted = FALSE;
