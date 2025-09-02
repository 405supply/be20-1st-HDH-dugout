-- 테스트 코드



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

