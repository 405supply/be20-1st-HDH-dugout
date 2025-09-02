INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (1, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 6), 22, 6, (SELECT away_team_id FROM game WHERE game_id = 6))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (2, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 6), 17, 6, (SELECT home_team_id FROM game WHERE game_id = 6))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (3, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 18), 11, 18, (SELECT away_team_id FROM game WHERE game_id = 18))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (4, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 8), 15, 8, (SELECT home_team_id FROM game WHERE game_id = 8))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (5, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 6), 21, 6, (SELECT away_team_id FROM game WHERE game_id = 6))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (6, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 14), 21, 14, (SELECT home_team_id FROM game WHERE game_id = 14))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (7, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 20), 1, 20, (SELECT away_team_id FROM game WHERE game_id = 20))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (8, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 19), 15, 19, (SELECT home_team_id FROM game WHERE game_id = 19))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (9, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 1), 13, 1, (SELECT away_team_id FROM game WHERE game_id = 1))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (10, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 9), 7, 9, (SELECT home_team_id FROM game WHERE game_id = 9))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (11, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 4), 19, 4, (SELECT away_team_id FROM game WHERE game_id = 4))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (12, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 11), 12, 11, (SELECT home_team_id FROM game WHERE game_id = 11))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (13, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 4), 15, 4, (SELECT away_team_id FROM game WHERE game_id = 4))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (14, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 16), 22, 16, (SELECT home_team_id FROM game WHERE game_id = 16))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (15, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 13), 20, 13, (SELECT away_team_id FROM game WHERE game_id = 13))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (16, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 4), 19, 4, (SELECT home_team_id FROM game WHERE game_id = 4))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (17, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 15), 12, 15, (SELECT away_team_id FROM game WHERE game_id = 15))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (18, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 10), 27, 10, (SELECT home_team_id FROM game WHERE game_id = 10))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (19, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 5), 22, 5, (SELECT away_team_id FROM game WHERE game_id = 5))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (20, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 8), 4, 8, (SELECT home_team_id FROM game WHERE game_id = 8))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (21, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 6), 4, 6, (SELECT away_team_id FROM game WHERE game_id = 6))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (22, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 5), 23, 5, (SELECT home_team_id FROM game WHERE game_id = 5))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (23, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 20), 14, 20, (SELECT away_team_id FROM game WHERE game_id = 20))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (24, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 13), 19, 13, (SELECT home_team_id FROM game WHERE game_id = 13))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (25, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 16), 6, 16, (SELECT away_team_id FROM game WHERE game_id = 16))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (26, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 6), 18, 6, (SELECT home_team_id FROM game WHERE game_id = 6))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (27, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 5), 10, 5, (SELECT away_team_id FROM game WHERE game_id = 5))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (28, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 15), 11, 15, (SELECT home_team_id FROM game WHERE game_id = 15))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (29, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 12), 28, 12, (SELECT away_team_id FROM game WHERE game_id = 12))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (30, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 5), 16, 5, (SELECT home_team_id FROM game WHERE game_id = 5))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (31, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 13), 27, 13, (SELECT away_team_id FROM game WHERE game_id = 13))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (32, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 16), 14, 16, (SELECT home_team_id FROM game WHERE game_id = 16))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (33, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 15), 23, 15, (SELECT away_team_id FROM game WHERE game_id = 15))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (34, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 3), 6, 3, (SELECT home_team_id FROM game WHERE game_id = 3))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (35, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 8), 26, 8, (SELECT away_team_id FROM game WHERE game_id = 8))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (36, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 9), 2, 9, (SELECT home_team_id FROM game WHERE game_id = 9))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (37, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 10), 18, 10, (SELECT away_team_id FROM game WHERE game_id = 10))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (38, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 15), 25, 15, (SELECT home_team_id FROM game WHERE game_id = 15))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (39, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 17), 18, 17, (SELECT away_team_id FROM game WHERE game_id = 17))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (40, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 4), 19, 4, (SELECT home_team_id FROM game WHERE game_id = 4))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (41, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 18), 25, 18, (SELECT away_team_id FROM game WHERE game_id = 18))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (42, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 2), 18, 2, (SELECT home_team_id FROM game WHERE game_id = 2))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (43, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 7), 18, 7, (SELECT away_team_id FROM game WHERE game_id = 7))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (44, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 8), 4, 8, (SELECT home_team_id FROM game WHERE game_id = 8))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (45, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 2), 28, 2, (SELECT away_team_id FROM game WHERE game_id = 2))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (46, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 12), 9, 12, (SELECT home_team_id FROM game WHERE game_id = 12))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (47, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 4), 15, 4, (SELECT away_team_id FROM game WHERE game_id = 4))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (48, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 19), 7, 19, (SELECT home_team_id FROM game WHERE game_id = 19))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (49, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 20), 28, 20, (SELECT away_team_id FROM game WHERE game_id = 20))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (50, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 20), 6, 20, (SELECT home_team_id FROM game WHERE game_id = 20))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (51, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 7), 26, 7, (SELECT away_team_id FROM game WHERE game_id = 7))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (52, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 2), 26, 2, (SELECT home_team_id FROM game WHERE game_id = 2))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (53, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 9), 18, 9, (SELECT away_team_id FROM game WHERE game_id = 9))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (54, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 10), 11, 10, (SELECT home_team_id FROM game WHERE game_id = 10))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (55, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 9), 19, 9, (SELECT away_team_id FROM game WHERE game_id = 9))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (56, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 14), 5, 14, (SELECT home_team_id FROM game WHERE game_id = 14))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (57, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 5), 9, 5, (SELECT away_team_id FROM game WHERE game_id = 5))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (58, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 5), 8, 5, (SELECT home_team_id FROM game WHERE game_id = 5))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (59, (SELECT DATE_SUB(`date`, INTERVAL 30 MINUTE) FROM game WHERE game_id = 8), 27, 8, (SELECT away_team_id FROM game WHERE game_id = 8))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);

INSERT INTO vote (vote_id, `date`, user_id, game_id, team_id)
VALUES (60, (SELECT DATE_SUB(`date`, INTERVAL 90 MINUTE) FROM game WHERE game_id = 5), 16, 5, (SELECT home_team_id FROM game WHERE game_id = 5))
ON DUPLICATE KEY UPDATE `date`=VALUES(`date`), team_id=VALUES(team_id);
