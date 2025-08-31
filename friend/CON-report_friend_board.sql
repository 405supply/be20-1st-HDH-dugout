-- 1) board_id를 NULL 허용(둘 중 하나만 쓰기 위해)
ALTER TABLE board_report
  MODIFY board_id INT NULL;

-- 2) friend_board_id 컬럼 추가
ALTER TABLE board_report
  ADD COLUMN friend_board_id INT NULL AFTER board_id;

-- 3) FK 추가 (friend_board → board_report)
ALTER TABLE board_report
  ADD CONSTRAINT fk_board_report_friend_board
  FOREIGN KEY (friend_board_id)
  REFERENCES friend_board (board_id)
  ON UPDATE RESTRICT
  ON DELETE RESTRICT;

-- 4) (선택) 친구찾기 게시글 중복신고 방지
ALTER TABLE board_report
  ADD UNIQUE KEY unique_report_friend_board (user_id, friend_board_id);

-- 5) (가능하면) 둘 중 하나만 채우도록 체크 (MySQL 8.0.16+)
ALTER TABLE board_report
  ADD CONSTRAINT chk_only_one_target
  CHECK ( (board_id IS NULL) <> (friend_board_id IS NULL) );
  
-- 친구찾기 게시글 하나 생성
INSERT INTO friend_board (user_id, title, `text`, gender, age)
VALUES (25, '같이 직관 가실 분', '토요일 경기 보실 분 구합니다', '무관', 28);

-- 방금 생성된 친구찾기 게시글에 대한 신고(신고자: user_id=25)
INSERT INTO board_report (user_id, board_id, friend_board_id, reason)
VALUES (25, NULL, LAST_INSERT_ID(), '스팸 의심');