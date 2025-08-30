UPDATE friend_comment
   SET `text` = '수정: 시간은 18:10에 만나면 좋겠습니다 :)',
       updated_at = CURRENT_TIMESTAMP
 WHERE comment_id = 41
   AND user_id    = 8
   AND is_deleted = 0;
