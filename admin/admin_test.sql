-- 관리자 기능 구현

-- 공지사항 등록 사용 예시

CALL admin_board_create(1, '업데이트 안내', '업데이트를 시작합니다.');
CALL admin_board_create(2, '업데이트 안내', '업데이트를 시작합니다.');


-- 공지사항 수정 사용 예시
CALL admin_board_update(4, '업데이트 내용 수정', '업데이트 내용 수정입니다.');


-- 공지사항 삭제 사용 예시
CALL admin_board_delete(4);


-- 회원 신고 조회
-- 1) 최근 30일, 전체 신고(처리/미처리 모두), 20건 0부터
CALL get_user_reports(NULL, NULL, NULL, DATE_SUB(NOW(), INTERVAL 30 DAY), NOW(), 20, 0);
-- 2) 피신고자(작성자) 25번의 미처리 신고만, 50건
CALL get_user_reports(25, NULL, 0, NULL, NULL, 50, 0);
-- 3) 신고자 7번이 만든 신고만, 2025-01-01~2025-12-31, 100건
CALL get_user_reports(NULL, 7, NULL, '2025-01-01 00:00:00', '2026-01-01 00:00:00', 100, 0);


-- 회원 정지 기능
-- 1) 지금부터 3일 정지
CALL suspend_user_for_days(25, 3);
-- 2) 특정 일시까지 정지
CALL suspend_user_until(25, '2025-09-30 23:59:59');


-- 회원 정지 해제
CALL unsuspend_user(25);


-- 정지된 회원 조회
CALL list_suspended_users();


-- 게시글 15회 이상 신고 누적시 자동 삭제
-- 기본 테스트 값 입력
INSERT INTO board_report (user_id, board_id, reason) VALUES
(1001, 33, '테스트 신고 1'),
(1002, 33, '테스트 신고 2'),
(1003, 33, '테스트 신고 3'),
(1004, 33, '테스트 신고 4'),
(1005, 33, '테스트 신고 5'),
(1006, 33, '테스트 신고 6'),
(1007, 33, '테스트 신고 7'),
(1008, 33, '테스트 신고 8'),
(1009, 33, '테스트 신고 9'),
(1010, 33, '테스트 신고 10'),
(1011, 33, '테스트 신고 11'),
(1012, 33, '테스트 신고 12'),
(1013, 33, '테스트 신고 13'),
(1014, 33, '테스트 신고 14');

-- 횟수 및 삭제여부 조회
SELECT COUNT(*) AS cnt_reports_14 FROM board_report WHERE board_id = 33;
SELECT board_id, is_deleted AS before_deleted FROM board WHERE board_id = 33;

-- 마지막 15번째 값 조회
INSERT INTO board_report (user_id, board_id, reason)
VALUES (1015, 33, '테스트 신고 15');


-- 댓글 10회이상 신고 누적시 자동 삭제
-- 기본 테스트 값 입력
INSERT INTO comment_report (user_id, comment_id, reason) VALUES
(101, 8, '테스트 신고 1'),
(102, 8, '테스트 신고 2'),
(103, 8, '테스트 신고 3'),
(104, 8, '테스트 신고 4'),
(105, 8, '테스트 신고 5'),
(106, 8, '테스트 신고 6'),
(107, 8, '테스트 신고 7'),
(108, 8, '테스트 신고 8'),
(109, 8, '테스트 신고 9');
-- 횟수 및 삭제여부 조회
SELECT COUNT(*) AS cnt_reports FROM comment_report WHERE comment_id = 8;
SELECT comment_id, is_deleted FROM comment WHERE comment_id = 8;
-- 마지막 10번째 값 조회
INSERT INTO comment_report (user_id, comment_id, reason)
VALUES (110, 8, '테스트 신고 10');