-- ==== 최종 테스트 ====

-- 게시글을 작성
CALL insert_board(3, 5, "제목: 요즘 날씨가 참 덥내요", "내용: 다들 감기 조심하세요");
CALL insert_board(4, 1, "제목: 오늘은 한화이글스 경기날", "내용: 응원합니다");



-- 전체 유저의 게시글 확인
CALL select_all_board();



-- 1번 유저의 게시글 확인
CALL mypage_posts_by_user(1);



-- 게시글 추천/비추천 하기 (유저ID, 게시글ID, 'U' or 'D')
CALL recommend_board(2, 42, 'U');



-- 게시글 상세 조회하기
CALL select_board_specific(42);



-- 인기 게시글 보기
CALL select_popular_board();



-- 북마크에 게시글 등록하기
CALL add_bookmark(42, 1);



-- 내가 북마크한 게시글 조회하기
CALL list_bookmarks(1);



-- 게시글에 댓글 달기
CALL insert_comment(4, 42, "댓글: 맞습니다~", NULL);



-- 게시글의 댓글 조회하기
CALL select_comment(42);



-- 게시글 신고 (유저ID/게시글ID/신고사유)
CALL report_board(1, 2, "광고글인거같아요!");
CALL report_board(2, 2, "광고글인거같아요!");
CALL report_board(3, 2, "광고글인거같아요!");
CALL report_board(4, 2, "광고글인거같아요!");
CALL report_board(5, 2, "광고글인거같아요!");
CALL report_board(6, 2, "광고글인거같아요!");
CALL report_board(7, 2, "광고글인거같아요!");
CALL report_board(8, 2, "광고글인거같아요!");
CALL report_board(9, 2, "광고글인거같아요!");
CALL report_board(10, 2, "광고글인거같아요!");
CALL report_board(11, 2, "광고글인거같아요!");
CALL report_board(12, 2, "광고글인거같아요!");
CALL report_board(13, 2, "광고글인거같아요!");
CALL report_board(14, 2, "광고글인거같아요!");
CALL report_board(15, 2, "광고글인거같아요!");



-- 15번 신고 누적, 게시글 자동 삭제됨
CALL select_board_specific(2); -- 조회되지않음
SELECT * FROM board WHERE board_id = 2; -- is_deleted = TRUE



-- 닉네임 변경
CALL user_update_nickname(1, '닉네임 수정 테스트 1');
SELECT * FROM user WHERE user_id = 1;



-- 1, 4번 유저 서로 팔로우하기
CALL add_follow(1, 4);
CALL add_follow(4, 1);



-- 내가 팔로우중인 유저 조회하기
CALL select_my_following(1);



-- 팔로우 취소하기
CALL cancle_follow(1, 3);
CALL cancle_follow(1, 8);



-- 내가 팔로우중인 유저 다시 조회하기
CALL select_my_following(1);



-- 친구찾기 게시글 등록하기
CALL friend_board_insert(
	1,
	10,
	5,
	3,
	'제목: 직관 같이 가실분~', 
	'내용: 같이 가실분을 구해요',
	'남자',
	24,
	@new_board_id
);
	
	
	
-- 친구찾기 게시글 상세조회
-- (키워드/성별/성별무관/나이최소/나이최대/도시코드/limit/offset)
CALL friend_board_search('직관', NULL, 0, 20, 35, NULL, 20, 0);



-- 나의 인적사항에 기반하여 친구 추천받기
-- 내부적으로 각 친구찾기 게시글의 정보에 따라 가중치를 적용하여
-- 높은 점수대로 친구 찾기 게시글을 조회합니다 
CALL friend_board_recommend(
  25,                          -- user_id (본인 제외)
  '여',                        -- gender
  25, 34,                      -- min_age, max_age
  2,                           -- city_id
  1,                           -- team_id
  '2025-08-20 00:00:00',       -- date_from
  '2025-08-22 00:00:00',       -- date_to
  10                           -- limit
);



-- 경기 내용 조회하기 (게임ID/경기장ID/날짜검색시작/날짜검색끝/년도/월)
CALL GetGames(1, NULL, '2025-08-01 00:00:00', '2025-08-31 23:59:59', 2025, 8);



-- 선수에게 평점 남기기
CALL ManagePlayerRating('upsert', 1, 1, 5, NULL, NULL, NULL);



-- 선수 전체 평점 조회 (평점높은순 출력)
CALL ManagePlayerRating('summary', NULL, NULL, NULL, NULL, NULL, NULL);



-- 유저의 포인트 조회 (게시글 등록/삭제, 댓글 등록/삭제, 팔로우에 따라 변동됨)
CALL user_point_logs(1);



-- 2025년 8월 25일 기준 주간 인기도 순위 계산
CALL GetWeeklyTeamPopularity('2025-08-25');



-- 경기에 대한 투표 결과 조회
CALL GetGameVoteResult(21);



-- 경기 승부예측(유저ID/경기ID/팀ID)
CALL CastVote(1, 21, 1, @ROWS);
CALL CastVote(2, 21, 2, @ROWS);
CALL CastVote(3, 21, 1, @ROWS);



-- 경기에 대한 투표 결과 재조회
CALL GetGameVoteResult(21);
