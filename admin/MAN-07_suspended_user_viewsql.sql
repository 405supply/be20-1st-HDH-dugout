-- 현재 정지중인 이용자 조회
SELECT user_id, nickname, suspension_end
FROM `user`
WHERE suspension_end > NOW()
ORDER BY suspension_end ASC;