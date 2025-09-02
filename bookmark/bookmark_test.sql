SELECT * FROM bookmark ORDER BY enrollment_time DESC;

CALL add_bookmark(23, 4);		-- 북마크 등록 테스트
CALL list_bookmarks(13);		-- 북마크 조회 테스트
CALL remove_bookmark(27, 13);	-- 북마크 삭제 테스트
