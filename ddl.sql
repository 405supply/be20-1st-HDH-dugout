-- =====================================================
-- DDL
-- =====================================================


-- 테이블 drop시 FK 제약조건을 무시하도록 함
SET FOREIGN_KEY_CHECKS = FALSE;

DROP TABLE IF EXISTS `diary`;
CREATE TABLE `diary` (
    `diary_id` INT NOT NULL AUTO_INCREMENT,
    `text` TEXT NOT NULL,
    `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    `is_deleted` BOOLEAN NULL DEFAULT FALSE,
    `is_public` BOOLEAN NULL DEFAULT FALSE,
    `user_id` INT NOT NULL,
    `game_id` INT NOT NULL,
    PRIMARY KEY (`diary_id`)
);

DROP TABLE IF EXISTS `player`;
CREATE TABLE `player` (
    `player_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `nationality` VARCHAR(50) NOT NULL,
    `height` INT NOT NULL,
    `weight` INT NOT NULL,
    `position` VARCHAR(50) NOT NULL,
    `uniform_number` INT NOT NULL,
    `debut_date` DATETIME NOT NULL,
    `retire_date` DATETIME NULL DEFAULT NULL,
    `career_highlight` TEXT NULL DEFAULT NULL,
    `throw_bat` VARCHAR(50) NOT NULL,
    `team_id` INT NOT NULL,
    PRIMARY KEY (`player_id`)
);

DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
    `category_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`category_id`)
);

DROP TABLE IF EXISTS `board_report`;
CREATE TABLE `board_report` (
  `board_report_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `board_id` INT NULL,
  `friend_board_id` INT NULL,
  `reason` TEXT NULL DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_handled` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`board_report_id`),
  UNIQUE KEY `unique_report_board` (`user_id`, `board_id`),
  UNIQUE KEY `unique_report_friend_board` (`user_id`, `friend_board_id`),
  CONSTRAINT `chk_only_one_target`
    CHECK ( (`board_id` IS NULL) <> (`friend_board_id` IS NULL) )
) 
;

DROP TABLE IF EXISTS `player_comment`;
CREATE TABLE `player_comment` (
    `player_comment_text_id` INT NOT NULL AUTO_INCREMENT,
    `text` TEXT NULL DEFAULT NULL,
    `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 자동 갱신
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `player_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    PRIMARY KEY (`player_comment_text_id`)
);

DROP TABLE IF EXISTS `user_block`;
CREATE TABLE `user_block` (
    `block_id` INT NOT NULL AUTO_INCREMENT,
    `blocker_id` INT NOT NULL,
    `blocked_id` INT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT unique_user_block UNIQUE(blocker_id, blocked_id), -- 중복 신고 방지 유니크 키 추가(09.01)
    PRIMARY KEY (`block_id`)
);

DROP TABLE IF EXISTS `bookmark`;
CREATE TABLE `bookmark` (
    `bookmark_id` INT NOT NULL AUTO_INCREMENT,
    `enrollment_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `board_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    CONSTRAINT unique_bookmark UNIQUE(board_id, user_id), -- 중복 북마크 방지 유니크 키 추가(09.02)
    PRIMARY KEY (`bookmark_id`)
);

DROP TABLE IF EXISTS `player_grade`;
CREATE TABLE `player_grade` (
    `player_rate_id` INT NOT NULL AUTO_INCREMENT,
    `score` INT NULL DEFAULT 0,
    `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 자동갱신
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `player_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    PRIMARY KEY (`player_rate_id`)
);

DROP TABLE IF EXISTS `friend_comment`;
CREATE TABLE `friend_comment` (
    `comment_id` INT NOT NULL AUTO_INCREMENT,
    `parent_comment_id` INT NULL DEFAULT NULL,
    `user_id` INT NOT NULL,
    `board_id` INT NOT NULL,
    `text` TEXT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP, 
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`comment_id`)
);

DROP TABLE IF EXISTS `team_popularity`;
CREATE TABLE `team_popularity` (
    `popularity_id` INT NOT NULL AUTO_INCREMENT,
    `point` INT NOT NULL DEFAULT 0,
    `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP, -- 자동 갱신
    `team_id` INT NOT NULL,
    PRIMARY KEY (`popularity_id`)
);

DROP TABLE IF EXISTS `friend_city`;
CREATE TABLE `friend_city` (
    `friend_city_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(20) NULL DEFAULT NULL,
    PRIMARY KEY (`friend_city_id`)
);

DROP TABLE IF EXISTS `post_attachment`;
CREATE TABLE `post_attachment` (
    `attachment_id` INT NOT NULL AUTO_INCREMENT,
    `file_name` VARCHAR(50) NOT NULL,
    `file_url` VARCHAR(50) NOT NULL,
    `file_size` INT DEFAULT NULL,
    `uploaded_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `type` ENUM('친구찾기_게시글', '친구찾기_댓글', '관리자_공지', '다이어리', '게시글', '댓글') NOT NULL,
    PRIMARY KEY (`attachment_id`)
);

DROP TABLE IF EXISTS `admin_board`;
CREATE TABLE `admin_board` (
    `board_id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `title` VARCHAR(50) NOT NULL,
    `text` TEXT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP, -- 자동갱신
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`board_id`)
);

DROP TABLE IF EXISTS `friend_board`;
CREATE TABLE `friend_board` (
    `board_id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `game_id` INT NULL DEFAULT NULL,
    `team_id` INT NULL DEFAULT NULL,
    `friend_city_id` INT NULL DEFAULT NULL,
    `title` VARCHAR(50) NOT NULL,
    `text` TEXT NOT NULL,
    `gender` CHAR(3) NULL DEFAULT NULL,
    `age` INT NULL DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP, -- 자동갱신
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`board_id`)
);

DROP TABLE IF EXISTS `team`;
CREATE TABLE `team` (
    `team_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `city` VARCHAR(50) NOT NULL,
    `founded_date` DATE NULL DEFAULT NULL,  -- DATETIME -> DATE
    `mascot` VARCHAR(50) NULL DEFAULT NULL,
    `color` VARCHAR(50) NULL DEFAULT NULL,
    `stadium_id` INT NOT NULL,
    PRIMARY KEY (`team_id`)
);

DROP TABLE IF EXISTS `game`;
CREATE TABLE `game` (
    `game_id` INT NOT NULL AUTO_INCREMENT,
    `date` DATETIME NOT NULL,
    `stadium_id` INT NOT NULL,
    `score` INT NULL DEFAULT 0,
    `home_team_id` INT NOT NULL,
    `away_team_id` INT NOT NULL,
    PRIMARY KEY (`game_id`)
);

DROP TABLE IF EXISTS `stadium`;
CREATE TABLE `stadium` (
    `stadium_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `city` VARCHAR(50) NOT NULL,
    `capacity` INT NULL DEFAULT 0,
    `roofed` BOOLEAN NOT NULL DEFAULT FALSE,
    `opened_date` DATE NULL DEFAULT NULL, -- DATETIME -> DATE
    PRIMARY KEY (`stadium_id`)
);

DROP TABLE IF EXISTS `comment_recommend`;
CREATE TABLE `comment_recommend` (
    `user_id` INT NOT NULL,
    `comment_id` INT NOT NULL,
    `type` ENUM('U','D') NOT NULL,
    CONSTRAINT unique_recommend_comment UNIQUE(user_id, comment_id, type)
);

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
    `user_id`    INT NOT NULL AUTO_INCREMENT,
    `team_id`    INT NOT NULL,
    `login_id`   VARCHAR(50)  NOT NULL,
    `login_pw`   VARCHAR(255) NOT NULL,
    `email`      VARCHAR(255) NOT NULL,
    `name`       VARCHAR(50)  NOT NULL,
    `nickname`   VARCHAR(50)  NOT NULL,
    `gender`     ENUM('M','F') NOT NULL,
    `birth_date` DATE NOT NULL,  -- DATETIME → DATE (시각 삭제)
    `point`      INT NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 자동 갱신
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `suspension_end` DATETIME NULL DEFAULT NULL,
    PRIMARY KEY (`user_id`),
    UNIQUE KEY `uk_user_login_id` (`login_id`),  -- 아이디 고유
    UNIQUE KEY `uk_user_email`    (`email`)      -- 이메일 고유
);

DROP TABLE IF EXISTS `follow`;
CREATE TABLE `follow` (
    `follow_id` INT NOT NULL AUTO_INCREMENT,
    `following_id` INT NOT NULL,
    `followed_id` INT NOT NULL,
    `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    `is_deleted` BOOLEAN NULL DEFAULT FALSE,
    CONSTRAINT `unique_following_followed` UNIQUE(`following_id`, `followed_id`),
    PRIMARY KEY (`follow_id`)
);

DROP TABLE IF EXISTS `board`;
CREATE TABLE `board` (
    `board_id` INT NOT NULL AUTO_INCREMENT,
    `category_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `title` VARCHAR(80) NOT NULL,
    `text` TEXT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP, -- 자동갱신
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`board_id`)
);

DROP TABLE IF EXISTS `vote`;
CREATE TABLE `vote` (
    `vote_id` INT NOT NULL AUTO_INCREMENT,
    `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `user_id` INT NOT NULL,
    `game_id` INT NOT NULL,
    `team_id` INT NOT NULL,
    PRIMARY KEY (`vote_id`)
);

DROP TABLE IF EXISTS `point_log`;
CREATE TABLE `point_log` (
    `point_id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `type` ENUM('post', 'comment', 'follow') NOT NULL,
    `action` ENUM('insert', 'delete') NOT NULL,
    `fluctuation` INT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`point_id`)
);

DROP TABLE IF EXISTS `board_recommend`;
CREATE TABLE `board_recommend` (
    `user_id` INT NOT NULL,
    `board_id` INT NOT NULL,
    `type` ENUM('U', 'D') NOT NULL,
    CONSTRAINT unique_recommend_board UNIQUE(user_id, board_id, type)
);

DROP TABLE IF EXISTS `comment_report`;
CREATE TABLE `comment_report` (
  `comment_report_id` INT NOT NULL AUTO_INCREMENT,
  `user_id`           INT NOT NULL,
  `comment_id`        INT NULL,
  `friend_comment_id` INT NULL,
  `reason`            TEXT NULL DEFAULT NULL,
  `created_at`        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_handled`        TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`comment_report_id`),
  UNIQUE KEY `unique_report_comment`       (`user_id`, `comment_id`),
  UNIQUE KEY `unique_report_friend_comment`(`user_id`, `friend_comment_id`),
  CONSTRAINT `chk_only_one_target`
    CHECK ( (comment_id IS NULL) <> (friend_comment_id IS NULL) )
);

DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
    `user_id` INT NOT NULL AUTO_INCREMENT,
    `login_id` VARCHAR(50) NOT NULL,
    `login_pw` VARCHAR(50) NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP, -- 자동갱신
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`user_id`)
);

DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
    `comment_id` INT NOT NULL AUTO_INCREMENT,
    `board_id` INT NOT NULL,
    `parent_comment_id` INT DEFAULT NULL,
    `user_id` INT NOT NULL,
    `text` TEXT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP, -- 자동갱신
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`comment_id`)
);

-- =====================================================
-- FK 제약 조건 
-- =====================================================

ALTER TABLE `diary` ADD CONSTRAINT `FK_user_TO_diary_1` FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`);
ALTER TABLE `diary` ADD CONSTRAINT `FK_game_TO_diary_1` FOREIGN KEY (`game_id`) REFERENCES `game`(`game_id`);
ALTER TABLE `player` ADD CONSTRAINT `FK_team_TO_player_1` FOREIGN KEY (`team_id`) REFERENCES `team`(`team_id`);
ALTER TABLE `board_report` ADD CONSTRAINT `FK_user_TO_board_report_1` FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`);
ALTER TABLE `board_report` ADD CONSTRAINT `FK_board_TO_board_report_1` FOREIGN KEY (`board_id`) REFERENCES `board`(`board_id`);
ALTER TABLE `player_comment` ADD CONSTRAINT `FK_player_TO_player_comment_1` FOREIGN KEY (`player_id`) REFERENCES `player`(`player_id`);
ALTER TABLE `player_comment` ADD CONSTRAINT `FK_user_TO_player_comment_1` FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`);
ALTER TABLE `user_block` ADD CONSTRAINT `FK_user_TO_user_block_1` FOREIGN KEY (`blocker_id`) REFERENCES `user`(`user_id`);
ALTER TABLE `user_block` ADD CONSTRAINT `FK_user_TO_user_block_2` FOREIGN KEY (`blocked_id`) REFERENCES `user`(`user_id`);
ALTER TABLE `bookmark` ADD CONSTRAINT `FK_board_TO_bookmark_1` FOREIGN KEY (`board_id`) REFERENCES `board`(`board_id`);
ALTER TABLE `bookmark` ADD CONSTRAINT `FK_user_TO_bookmark_1` FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`);
ALTER TABLE `player_grade` ADD CONSTRAINT `FK_player_TO_player_grade_1` FOREIGN KEY (`player_id`) REFERENCES `player`(`player_id`);
ALTER TABLE `player_grade` ADD CONSTRAINT `FK_user_TO_player_grade_1` FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`);
ALTER TABLE `friend_comment` ADD CONSTRAINT `FK_friend_comment_TO_friend_comment_1` FOREIGN KEY (`parent_comment_id`) REFERENCES `friend_comment`(`comment_id`);
ALTER TABLE `friend_comment` ADD CONSTRAINT `FK_user_TO_friend_comment_1` FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`);
ALTER TABLE `friend_comment` ADD CONSTRAINT `FK_friend_board_TO_friend_comment_1` FOREIGN KEY (`board_id`) REFERENCES `friend_board`(`board_id`);
ALTER TABLE `team_popularity` ADD CONSTRAINT `FK_team_TO_team_popularity_1` FOREIGN KEY (`team_id`) REFERENCES `team`(`team_id`);
ALTER TABLE `admin_board` ADD CONSTRAINT `FK_admin_TO_admin_board_1` FOREIGN KEY (`user_id`) REFERENCES `admin`(`user_id`);
ALTER TABLE `friend_board` ADD CONSTRAINT `FK_user_TO_friend_board_1` FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`);
ALTER TABLE `friend_board` ADD CONSTRAINT `FK_game_TO_friend_board_1` FOREIGN KEY (`game_id`) REFERENCES `game`(`game_id`);
ALTER TABLE `friend_board` ADD CONSTRAINT `FK_team_TO_friend_board_1` FOREIGN KEY (`team_id`) REFERENCES `team`(`team_id`);
ALTER TABLE `friend_board` ADD CONSTRAINT `FK_friend_city_TO_friend_board_1` FOREIGN KEY (`friend_city_id`) REFERENCES `friend_city`(`friend_city_id`);
ALTER TABLE `team` ADD CONSTRAINT `FK_stadium_TO_team_1` FOREIGN KEY (`stadium_id`) REFERENCES `stadium`(`stadium_id`);
ALTER TABLE `game` ADD CONSTRAINT `FK_stadium_TO_game_1` FOREIGN KEY (`stadium_id`) REFERENCES `stadium`(`stadium_id`);
ALTER TABLE `game` ADD CONSTRAINT `FK_team_TO_game_1` FOREIGN KEY (`home_team_id`) REFERENCES `team`(`team_id`);
ALTER TABLE `game` ADD CONSTRAINT `FK_team_TO_game_2` FOREIGN KEY (`away_team_id`) REFERENCES `team`(`team_id`);
ALTER TABLE `comment_recommend` ADD CONSTRAINT `FK_user_TO_comment_recommend_1` FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`);
ALTER TABLE `comment_recommend` ADD CONSTRAINT `FK_comment_TO_comment_recommend_1` FOREIGN KEY (`comment_id`) REFERENCES `comment`(`comment_id`);
ALTER TABLE `user` ADD CONSTRAINT `FK_team_TO_user_1` FOREIGN KEY (`team_id`) REFERENCES `team`(`team_id`);
ALTER TABLE `follow` ADD CONSTRAINT `FK_user_TO_follow_1` FOREIGN KEY (`following_id`) REFERENCES `user`(`user_id`);
ALTER TABLE `follow` ADD CONSTRAINT `FK_user_TO_follow_2` FOREIGN KEY (`followed_id`) REFERENCES `user`(`user_id`);
ALTER TABLE `board` ADD CONSTRAINT `FK_category_TO_board_1` FOREIGN KEY (`category_id`) REFERENCES `category`(`category_id`);
ALTER TABLE `board` ADD CONSTRAINT `FK_user_TO_board_1` FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`);
ALTER TABLE `vote` ADD CONSTRAINT `FK_user_TO_vote_1` FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`);
ALTER TABLE `vote` ADD CONSTRAINT `FK_game_TO_vote_1` FOREIGN KEY (`game_id`) REFERENCES `game`(`game_id`);
ALTER TABLE `vote` ADD CONSTRAINT `FK_team_TO_vote_1` FOREIGN KEY (`team_id`) REFERENCES `team`(`team_id`);
ALTER TABLE `point_log` ADD CONSTRAINT `FK_user_TO_point_log_1` FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`);
ALTER TABLE `board_recommend` ADD CONSTRAINT `FK_user_TO_board_recommend_1` FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`);
ALTER TABLE `board_recommend` ADD CONSTRAINT `FK_board_TO_board_recommend_1` FOREIGN KEY (`board_id`) REFERENCES `board`(`board_id`);
ALTER TABLE `comment_report` ADD CONSTRAINT `FK_user_TO_comment_report_1` FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`);
ALTER TABLE `comment_report` ADD CONSTRAINT `FK_comment_TO_comment_report_1` FOREIGN KEY (`comment_id`) REFERENCES `comment`(`comment_id`);
ALTER TABLE `comment` ADD CONSTRAINT `FK_board_TO_comment_1` FOREIGN KEY (`board_id`) REFERENCES `board`(`board_id`);
ALTER TABLE `comment` ADD CONSTRAINT `FK_comment_TO_comment_1` FOREIGN KEY (`parent_comment_id`) REFERENCES `comment`(`comment_id`);
ALTER TABLE `comment` ADD CONSTRAINT `FK_user_TO_comment_1` FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`);
ALTER TABLE `board_report` ADD CONSTRAINT `FK_board_report_friend_board` FOREIGN KEY (`friend_board_id`) REFERENCES friend_board (`board_id`) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE `comment_report` ADD CONSTRAINT `FK_comment_report_friend_comment` FOREIGN KEY (`friend_comment_id`) REFERENCES `friend_comment` (`comment_id`) ON UPDATE RESTRICT ON DELETE RESTRICT;