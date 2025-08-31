-- 회원가입
CALL user_signup(5, 'p_test', 'p_test123', 'p_test@ex.com', '프로시저_테스트', '프테', 'M', '2000-12-15');

SELECT * FROM `user`;

-- 로그인 체크
CALL user_login_check('p_test', 'p_test123');

-- 닉네임 변경
CALL user_update_nickname(34, 'p_닉네임수정테스트');

-- 아이디 찾기
CALL user_find_id_by_email('p_test@ex.com');

-- 비밀번호 재설정
CALL user_reset_password_by_login('p_test', 'p_changePW');

-- 탈퇴
CALL user_soft_delete(34);

-- 차단/해제
CALL user_block_add(34, 1);
CALL user_block_cancel_by_id(34, 1);

-- 마이페이지
CALL mypage_posts_by_user(6);
CALL mypage_comments_by_user(6);

-- 다이어리
CALL diary_add(4, 20, '오늘 경기 후기~');
CALL diary_delete(22);
CALL diary_list_by_user(4);

SELECT * FROM diary WHERE diary_id = 22;

-- 포인트/포인트 로그/북마크
CALL user_point_get(4);
CALL user_point_logs(4);
CALL user_bookmarks(4);
