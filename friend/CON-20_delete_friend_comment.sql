UPDATE friend_comment
   SET is_deleted = 1,
       updated_at = CURRENT_TIMESTAMP
 WHERE comment_id = 41     -- 위에서 막 등록된 댓글
   AND user_id    = 8
   AND is_deleted = 0;
