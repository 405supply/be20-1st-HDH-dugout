DELIMITER $$

CREATE PROCEDURE GetGames(
    IN p_team_id INT,
    IN p_stadium_id INT,
    IN p_start_date DATETIME,
    IN p_end_date DATETIME,
    IN p_year INT,
    IN p_month INT
)
BEGIN
    SELECT
        g.game_id,
        g.date,
        g.score,
        ht.name AS home_team,
        at.name AS away_team,
        s.name  AS stadium,
        s.city  AS stadium_city
    FROM game g
    JOIN team ht ON g.home_team_id = ht.team_id
    JOIN team at ON g.away_team_id = at.team_id
    JOIN stadium s ON g.stadium_id = s.stadium_id
    WHERE
        (p_team_id    IS NULL OR g.home_team_id = p_team_id OR g.away_team_id = p_team_id)
    AND (p_stadium_id IS NULL OR g.stadium_id   = p_stadium_id)
    AND (p_start_date IS NULL OR g.date >= p_start_date)
    AND (p_end_date   IS NULL OR g.date < DATE_ADD(p_end_date, INTERVAL 1 SECOND))
    AND (
          p_year IS NULL
       OR (
            (p_month IS NULL
              AND g.date >= MAKEDATE(p_year, 1)
              AND g.date <  DATE_ADD(MAKEDATE(p_year, 1), INTERVAL 1 YEAR)
            )
         OR (p_month IS NOT NULL
              AND g.date >= STR_TO_DATE(CONCAT(p_year,'-',LPAD(p_month,2,'0'),'-01'), '%Y-%m-%d')
              AND g.date <  DATE_ADD(STR_TO_DATE(CONCAT(p_year,'-',LPAD(p_month,2,'0'),'-01'), '%Y-%m-%d'), INTERVAL 1 MONTH)
            )
          )
        )
    ORDER BY g.date DESC, g.game_id DESC;
END $$

DELIMITER ;
