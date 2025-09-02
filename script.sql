-- ==== 최종 테스트 ====

-- 1번 유저가 작성한 게시글 조회
CALL mypage_posts_by_user(1);

-- 1번 유저가 게시글을 작성
CALL insert_board(4, 1, "제목: 오늘은 SSG 랜더스 경기날", "내용: 응원합니다");

-- 1번 유저의 게시글 재확인
CALL mypage_posts_by_user(1);

-- 방금 적은 게시글 추천하기
CALL recommend_board(1, 48, 'U');

-- 방금 추천한 게시글 상세 조회하기
CALL select_board_specific(48);

-- 인기 게시글 보기
CALL select_popular_board();

-- 북마크에 게시글 등록하기
CALL add_bookmark(48, 1);

-- 내가 북마크한 게시글 조회하기
CALL list_bookmarks(1);

-- 48번 게시글에 댓글 달기
CALL insert_comment(1, 48, "댓글: 맞습니다~", NULL);

-- 48번 게시글의 댓글 조회하기
CALL select_comment(48);

-- 닉네임 변경
CALL user_update_nickname(1, '닉네임 수정 테스트 1');
SELECT * FROM user WHERE user_id = 1;

-- 2번 유저 팔로우하기
CALL add_follow(1, 2);
CALL add_follow(2, 1);

-- 내가 팔로우중인 유저 조회하기
CALL select_my_following(1);

-- 팔로우 취소하기
CALL cancle_follow(1, 3);
CALL cancle_follow(1, 8);

-- 내가 팔로우중인 유저 다시 조회하기
CALL select_my_following(1);

-- 친구찾기 게시글 등록하기
CALL friend_board_insert(1, 10, 5, 3,
	"제목: 직관 같이 가실분~", 
	"내용: 같이 가실분을 구해요",
	'남자',
	24
	);
	
-- 친구찾기 게시글 상세조회 (키워드/성별/성별무관/나이최소/나이최대/도시코드/리밋/오프셋)
CALL friend_board_search('직관', NULL, 0, 20, 35, NULL, 20, 0);

-- 나의 인적사항에 기반하여 친구 추천받기
-- 내부적으로 각 친구찾기 게시글의 정보에 따라 가중치를 적용하여
-- 높은 점수대로 친구 찾기 게시글을 조회합니다 
CALL friend_board_recommend(
  25,                          -- p_user_id (본인 제외)
  '여',                        -- p_gender
  25, 34,                      -- p_min_age, p_max_age
  2,                           -- p_city_id
  1,                           -- p_team_id
  '2025-08-20 00:00:00',       -- p_date_from
  '2025-08-22 00:00:00',       -- p_date_to
  10                           -- p_limit
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

-- 경기 승부예측(유저ID/경기ID/팀ID)
CALL CastVote(1, 22, 3, @ROWS);

-- 22번경기에 대한 투표 현황 조회
CALL GetGameVoteSnapshot(22);



