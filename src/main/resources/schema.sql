DROP DATABASE TODOLIST;

CREATE DATABASE IF NOT EXISTS TODOLIST; -- 만약을 위해 IF NOT EXISTS 추가!

USE TODOLIST; -- 작업할 데이터베이스 선택!

CREATE TABLE User (
                       user_id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                       email VARCHAR(100) NOT NULL UNIQUE,
                       password VARCHAR(100) NOT NULL,
                       user_name VARCHAR(45) NOT NULL,
                       created_at DATETIME DEFAULT CURRENT_TIMESTAMP -- create_at -> created_at 오타 수정 제안 (일관성을 위해)
);

CREATE TABLE Team (
                      team_id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                      team_name VARCHAR(100) NOT NULL,
                      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Team_Member (
                             team_member_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
                             role ENUM ('member','admin') NOT NULL DEFAULT 'member',
                             status ENUM ('active','left','kicked','pending') NOT NULL DEFAULT 'active',
                             joined_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 이전 줄 끝에 쉼표(,) 추가!
                             user_id INT UNSIGNED NOT NULL, -- User 테이블의 user_id가 INT이므로 UNSIGNED를 꼭 써야 하는지 확인 필요 (MySQL은 보통 허용)
                             team_id INT UNSIGNED NOT NULL, -- Team 테이블의 team_id가 INT이므로 UNSIGNED를 꼭 써야 하는지 확인 필요
                             CONSTRAINT fk_team_member_user FOREIGN KEY (user_id) REFERENCES User(user_id), -- 요기!
                             CONSTRAINT fk_team_member_team FOREIGN KEY (team_id) REFERENCES Team(team_id)
);

CREATE TABLE Team_Invite (
                             invite_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
                             invitee_email VARCHAR(100) NOT NULL,
                             status ENUM('pending','accepted','rejected','expired') NOT NULL DEFAULT 'pending',
                             created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                             responded_at DATETIME,
                             inviter_id INT UNSIGNED NOT NULL, -- PRIMARY KEY 중복 선언 제거
                             team_id INT UNSIGNED NOT NULL,   -- PRIMARY KEY 중복 선언 제거
                             CONSTRAINT fk_team_invite_inviter FOREIGN KEY (inviter_id) REFERENCES User(user_id), -- 올바른 FK 구문
                             CONSTRAINT fk_team_invite_team FOREIGN KEY (team_id) REFERENCES Team(team_id)     -- 올바른 FK 구문
);


CREATE TABLE Task (
                      task_id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                      title VARCHAR(100) NOT NULL,
                      description MEDIUMTEXT,
                      due_date DATETIME,
                      status ENUM('pending','done') NOT NULL DEFAULT 'pending',
                      is_team_task TINYINT(1) NOT NULL DEFAULT 0, -- MySQL에서 BOOLEAN 대신 TINYINT(1) 쓰는 거 좋아!
                      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                      user_id INT UNSIGNED NOT NULL, -- User.user_id가 INT이므로, 여기도 INT. UNSIGNED 여부는 일관성 고려.
                      team_id INT UNSIGNED NOT NULL, -- Team.team_id가 INT이므로, 여기도 INT. UNSIGNED 여부는 일관성 고려.
    -- 만약 team_id가 NULL을 허용해야 한다면 NOT NULL 제거 필요
                      CONSTRAINT fk_task_user FOREIGN KEY (user_id) REFERENCES User(user_id), -- 올바른 FK 구문
                      CONSTRAINT fk_task_team FOREIGN KEY (team_id) REFERENCES Team(team_id)  -- 올바른 FK 구문
);

CREATE TABLE Alarm (
                       alarm_id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                       alert_offset INT UNSIGNED NOT NULL, -- 어떤 기준으로 offset을 잡는지에 따라 의미가 중요할 듯!
                       notified TINYINT(1) NOT NULL DEFAULT 0, -- DEFAULT 값도 넣어주면 좋지!
                       created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       task_id INT UNSIGNED NOT NULL, -- PRIMARY KEY 중복 선언 제거. Task.task_id가 INT이므로 UNSIGNED 일관성 확인.
                       user_id INT UNSIGNED NOT NULL, -- PRIMARY KEY 중복 선언 제거. User.user_id가 INT이므로 UNSIGNED 일관성 확인.
                       CONSTRAINT fk_alarm_task FOREIGN KEY (task_id) REFERENCES Task(task_id), -- 올바른 FK 구문
                       CONSTRAINT fk_alarm_user FOREIGN KEY (user_id) REFERENCES User(user_id)  -- User 테이블을 참조하도록 수정 (원래 Team(team_id)였는데, Alarm 테이블에 team_id 컬럼이 없었음)
);