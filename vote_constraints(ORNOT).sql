-- 같은 유저가 같은 경기엔 1번만 투표
ALTER TABLE `vote`
  ADD CONSTRAINT `uq_vote_user_game` UNIQUE (`user_id`, `game_id`);