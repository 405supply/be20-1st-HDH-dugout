-- 친구 기능 구현 테스트 값
-- 친구 찾기 게시글 등록
CALL friend_board_insert(
    25,          -- p_user_id
    20,          -- p_game_id
    1,           -- p_team_id
    2,           -- p_friend_city_id
    '8/21 사직 원정 같이 가요',            -- p_title
    '응원가 같이 연습하실 분 환영합니다!', -- p_text
    '무관',      -- p_gender
    34,          -- p_age
    @new_board_id
);

-- 친구 찾기 게시글 수정
CALL friend_board_update(
  7,           -- p_board_id
  8,           -- p_user_id
  '8/21 사직 외야석 같이 가요',
  '티켓 예매 완료, 경기 전 간단히 만나요',
  '무관',      -- p_gender
  33,          -- p_age
  20,          -- p_game_id
  1,           -- p_team_id
  2            -- p_friend_city_id
);


-- 친구 찾기 게시글 삭제
CALL friend_board_soft_delete(7, 8);

-- 친구 찾기 게시글 조회
--  전체 게시글 조회 사용 예시 
CALL board_list_paged(20, 0);
-- 게시글 상세 조회 사용 예시 
CALL friend_board_search('주말', NULL, 1, 20, 35, 4, 20, 0);


-- 친구 찾기 댓글 등록
CALL friend_comment_create(NULL, 8, 1, '직관 같이 보실 분? 저녁 경기로 생각 중입니다!');


-- 친구 찾기 댓글 수정 
CALL friend_comment_update(41, 8, '수정: 시간은 18:10에 만나면 좋겠습니다 :)');


-- 친구 찾기 댓글 삭제
CALL friend_comment_delete(41, 8);


-- 친구 찾기 맞춤형 기능 구현
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