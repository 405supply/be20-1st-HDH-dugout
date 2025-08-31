-- 정지중인 이용자 테스트 값 입력
INSERT INTO `user`
  (`team_id`,`login_id`,`login_pw`,`email`,`name`,`nickname`,`gender`,
   `birth_date`,`point`,`suspension_end`)
VALUES
  (1,'ssblue01','P@ssw0rd!','ssblue01@example.com','김현수','삼성직관러','M','1992-06-15',120, DATE_ADD(NOW(), INTERVAL 2 DAY)),
  (2,'lottefan02','P@ssw0rd!','lottefan02@example.com','박지민','롯데우승가자','F','1996-11-03', 50, DATE_ADD(NOW(), INTERVAL 12 HOUR));

-- 사용자 정지 관리 속성 추가
ALTER TABLE `user`
  ADD COLUMN `suspension_end` DATETIME NULL DEFAULT NULL;
  
-- 신고정지(지금부터 3일간)
UPDATE `user`
SET suspension_end = DATE_ADD(NOW(), INTERVAL 3 DAY)
WHERE user_id = 25 AND is_deleted = 0;

-- 신고정지(특정 기간까지)
UPDATE `user`
SET suspension_end = '2025-09-30 23:59:59'
WHERE user_id = 25 AND is_deleted = 0;