
CREATE DATABASE IF NOT EXISTS DBTeam04
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE DBTeam04;


# 1. Genre 테이블 생성
CREATE TABLE Genre (
    genre_id    INT             NOT NULL AUTO_INCREMENT,
    genre_name  VARCHAR(50)     NOT NULL,
 
    PRIMARY KEY (genre_id),
    CONSTRAINT uq_genre_name UNIQUE (genre_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
# 2. Platform 테이블 생성
CREATE TABLE Platform (
    platform_id     INT             NOT NULL AUTO_INCREMENT,
    platform_name   VARCHAR(100)    NOT NULL,
    platform_price   DECIMAL(10, 2),            
 
    PRIMARY KEY (platform_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
 
 # 3. Content 테이블 생성
 
CREATE TABLE Content (
    content_id      INT             NOT NULL AUTO_INCREMENT,
    title           VARCHAR(200)    NOT NULL,
    content_type    VARCHAR(50)     NOT NULL,   
    release_year    INT,
    age_rating      VARCHAR(20),                
    description     TEXT,
 
    PRIMARY KEY (content_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
 # 4. ContentGenre (콘텐츠-장르 연결 테이블 N:M)
 
CREATE TABLE ContentGenre (
    content_id  INT     NOT NULL,
    genre_id    INT     NOT NULL,
 
    PRIMARY KEY (content_id, genre_id),
    CONSTRAINT fk_cg_content    FOREIGN KEY (content_id)    REFERENCES Content(content_id)  ON DELETE CASCADE,
    CONSTRAINT fk_cg_genre      FOREIGN KEY (genre_id)      REFERENCES Genre(genre_id)      ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
 # 5. PlatformContent (특정 플랫폼의 콘텐츠 정보 - 핵심)

CREATE TABLE PlatformContent (
    pc_id               INT             NOT NULL AUTO_INCREMENT,
    content_id          INT             NOT NULL,
    platform_id         INT             NOT NULL,
    platform_rating     DECIMAL(3, 1),          
    is_available        BOOLEAN         NOT NULL DEFAULT TRUE,
    added_at            DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
 
    PRIMARY KEY (pc_id),
    CONSTRAINT uq_pc_content_platform UNIQUE (content_id, platform_id),
    CONSTRAINT fk_pc_content    FOREIGN KEY (content_id)    REFERENCES Content(content_id)  ON DELETE CASCADE,
    CONSTRAINT fk_pc_platform   FOREIGN KEY (platform_id)   REFERENCES Platform(platform_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
 # 6. Users(회원 정보 및 권한관리)

CREATE TABLE Users (
    user_id         INT             NOT NULL AUTO_INCREMENT,
    username        VARCHAR(100)    NOT NULL,
    email           VARCHAR(200)    NOT NULL,
    password        VARCHAR(255)    NOT NULL,
    role            VARCHAR(20)     NOT NULL DEFAULT 'USER',    -- USER / ADMIN
    membership      VARCHAR(50)     NOT NULL DEFAULT 'FREE',    -- FREE / BASIC / STANDARD / PREMIUM
    status          VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE',  -- ACTIVE / INACTIVE / BANNED
    signup_date     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
 
    PRIMARY KEY (user_id),
    CONSTRAINT uq_users_email UNIQUE (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
 
 
#7. WatchHistory(사용자의 플랫폼별 시청 기록)

CREATE TABLE WatchHistory (
    history_id      INT             NOT NULL AUTO_INCREMENT,
    user_id         INT             NOT NULL,
    pc_id           INT             NOT NULL,
    watch_status    VARCHAR(20)     NOT NULL DEFAULT 'WATCHING', 
    watched_date    DATETIME,                                          
 
    PRIMARY KEY (history_id),
    CONSTRAINT fk_wh_user   FOREIGN KEY (user_id)   REFERENCES Users(user_id)           ON DELETE CASCADE,
    CONSTRAINT fk_wh_pc     FOREIGN KEY (pc_id)     REFERENCES PlatformContent(pc_id)   ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
 
 
 #8. Review 테이블
CREATE TABLE Review (
    review_id       INT         NOT NULL AUTO_INCREMENT,
    user_id         INT         NOT NULL,
    pc_id           INT         NOT NULL,
    rating          INT         NOT NULL,           
    review_text     TEXT,
    review_date     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_spoiler      BOOLEAN     NOT NULL DEFAULT FALSE,
 
    PRIMARY KEY (review_id),
    CONSTRAINT uq_rv_user_pc UNIQUE (user_id, pc_id),
    CONSTRAINT fk_rv_user   FOREIGN KEY (user_id)   REFERENCES Users(user_id)           ON DELETE CASCADE,
    CONSTRAINT fk_rv_pc     FOREIGN KEY (pc_id)     REFERENCES PlatformContent(pc_id)   ON DELETE CASCADE,
    CONSTRAINT chk_rating   CHECK (rating BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


 #9. UserSubscription 테이블
CREATE TABLE UserSubscription (
    user_id         INT     NOT NULL,
    platform_id     INT     NOT NULL,
 
    PRIMARY KEY (user_id, platform_id),
    CONSTRAINT fk_us_user       FOREIGN KEY (user_id)       REFERENCES Users(user_id)        ON DELETE CASCADE,
    CONSTRAINT fk_us_platform   FOREIGN KEY (platform_id)   REFERENCES Platform(platform_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 



 
