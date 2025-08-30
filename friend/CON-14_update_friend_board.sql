-- 친구찾기 게시글 수정
UPDATE friend_board
   SET title = '8/21 사직 외야석 같이 가요',
       text  = '티켓 예매 완료, 경기 전 간단히 만나요',
       gender = '무관',
       age = 33,
       game_id = 20,
       team_id = 1,
       friend_city_id = 2
 WHERE board_id = 7
   AND user_id  = 8
   AND is_deleted = 0;