-- 테스트 코드
-- ===========

CALL select_all_board();


CALL select_board_by_category(6);


CALL select_board_specific(5);


CALL report_board(17, 4, "광고글임");
SELECT * from board_report ORDER BY created_at DESC LIMIT 3; 


CALL insert_board(
	2,
	10, 
	"반갑게시글제목",
	"안녕게시글내용"
	);
SELECT * FROM board ORDER BY created_at DESC LIMIT 10;
SELECT * FROM point_log ORDER BY created_at DESC LIMIT 3;
	
	
CALL edit_board(
	"수정한게시글제목",
	"수정한게시글내용",
	41,
	4
);
CALL select_board_specific(41);


CALL delete_board(41);


CALL select_board_specific(41);


CALL recommend_board(
	9,
	41,
	'D'
);
SELECT * FROM board_recommend;


CALL select_popular_board();