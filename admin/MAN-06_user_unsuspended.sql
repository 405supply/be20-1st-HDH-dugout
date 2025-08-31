--- 신고 즉시 해제
UPDATE `user`
SET suspension_end = NULL
WHERE user_id = 25;