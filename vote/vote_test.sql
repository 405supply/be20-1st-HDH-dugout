-- 주요 테이블 조회
CALL CheckBaseCounts();

-- 특정 유저가 특정 경기에서 팀을 선택해 투표
-- 유저 id 1인 사람이, 5번 경기, 5번 팀에 투표
CALL CastVote(1, 5, 5, @rows); SELECT @rows AS rows_affected;

-- 5번 경기에 대한 팀 별 투표수 조회
CALL GetGameVoteSnapshot(5);

-- 16번 경기에 대한 최종 투표 결과
CALL GetGameVoteResult(16);

-- 전체 경기 혹은 특정 경기 투표 결과 조회
-- p_game_id를 NULL로 지정하여 전체 경기에 대해 조회
CALL GetHistoricalVoteResults(NULL, 100);
