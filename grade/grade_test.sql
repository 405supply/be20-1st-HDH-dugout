-- 1) 선수 업서트 (user 1이 player 1에게 5점)
CALL ManagePlayerRating('upsert', 1, 1, 5, NULL, NULL, NULL);

-- 2) 투표 취소 (soft delete)
CALL ManagePlayerRating('delete', 1, 1, NULL, NULL, NULL, NULL);

-- 3) 팀별 선수 리스트 (team 1, 상위 10명)
CALL ManagePlayerRating('team_list', NULL, NULL, NULL, 1, 10, 0);

-- 4) 특정 선수 상세 조회 (player 1)
CALL ManagePlayerRating('player_detail', 1, NULL, NULL, NULL, NULL, NULL);

-- 5) 전체 선수 평점 요약
CALL ManagePlayerRating('summary', NULL, NULL, NULL, NULL, NULL, NULL);
