-- 1) 기존 comment_id를 NULL 허용 (둘 중 하나만 쓰기 위해)
ALTER TABLE comment_report
  MODIFY comment_id INT NULL;

-- 2) friend_comment_id 컬럼 추가
ALTER TABLE comment_report
  ADD COLUMN friend_comment_id INT NULL AFTER comment_id;

-- 3) FK 추가 (friend_comment → comment_report)
ALTER TABLE comment_report
  ADD CONSTRAINT fk_comment_report_friend_comment
  FOREIGN KEY (friend_comment_id)
  REFERENCES friend_comment (comment_id)
  ON UPDATE RESTRICT
  ON DELETE RESTRICT;

-- 4) 중복신고 방지(친구찾기용)
ALTER TABLE comment_report
  ADD UNIQUE KEY unique_report_friend_comment (user_id, friend_comment_id);

-- 5) (선택) 두 타깃 중 정확히 하나만 채우도록 체크 (MySQL 8.0.16+)
ALTER TABLE comment_report
  ADD CONSTRAINT chk_only_one_target
  CHECK ( (comment_id IS NULL) <> (friend_comment_id IS NULL) );
  
-- 친구찾기 댓글 하나 생성
INSERT INTO friend_comment (user_id, board_id, `text`)
VALUES (26, 17, '친구 구해요! 토요일 직관 가실 분?');

-- 방금 생성된 친구찾기 댓글을 신고(신고자: user_id=26)
INSERT INTO comment_report (user_id, comment_id, friend_comment_id, reason)
VALUES (26, NULL, LAST_INSERT_ID(), '부적절한 표현');