-- 친구찾기 게시글 삭제
UPDATE friend_board
   SET is_deleted = 1
 WHERE board_id = 7
   AND user_id  = 8 
   AND is_deleted = 0;