-- ✅ 점수 제약조건 (1~5)
ALTER TABLE `player_grade`
  ADD CONSTRAINT `CHK_score_1_5` CHECK (`score` BETWEEN 1 AND 5);
