-- 모든 매개변수 지정
CALL GetGames(1, NULL, '2025-08-01 00:00:00', '2025-08-31 23:59:59', 2025, 8);

-- 팀만 지정
CALL GetGames(1, NULL, NULL, NULL, NULL, NULL);

-- 날짜 범위만 지정
CALL GetGames(NULL, NULL, '2025-08-01', '2025-08-31', NULL, NULL);

-- 아무 조건도 없는 경우
CALL GetGames(NULL, NULL, NULL, NULL, NULL, NULL);
