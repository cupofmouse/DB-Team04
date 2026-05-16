-- View 생성 코드1 [콘텐츠 검색 및 조회] >> (5. 콘텐츠 상세 정보 조회)
CREATE VIEW v_content_detail AS
SELECT 
    c.content_id,
    c.title AS '제목',
    c.content_type AS '유형',
    g.genre_name AS '장르',
    p.platform_name AS '플랫폼',
    pc.platform_rating AS '플랫폼평점'
FROM Content c
JOIN ContentGenre cg ON c.content_id = cg.content_id
JOIN Genre g ON cg.genre_id = g.genre_id
JOIN PlatformContent pc ON c.content_id = pc.content_id
JOIN Platform p ON pc.platform_id = p.platform_id;

-- View 생성 코드2 [내 시청 기록 관리] >> (2. 내 시청 기록 조회)
CREATE VIEW v_my_watch_history AS
SELECT 
    u.username AS '사용자',
    c.title AS '콘텐츠제목',
    p.platform_name AS '플랫폼',
    wh.watch_status AS '시청상태',
    wh.watched_date AS '시청일자'
FROM WatchHistory wh
JOIN Users u ON wh.user_id = u.user_id
JOIN PlatformContent pc ON wh.pc_id = pc.pc_id
JOIN Content c ON pc.content_id = c.content_id
JOIN Platform p ON pc.platform_id = p.platform_id;

-- JOIN 쿼리용 [인기 콘텐츠 및 추천 조회] >> (1. 전체 인기 콘텐츠 조회)
SELECT c.title, COUNT(wh.history_id) AS view_count
FROM Content c
JOIN PlatformContent pc ON c.content_id = pc.content_id
JOIN WatchHistory wh ON pc.pc_id = wh.pc_id
GROUP BY c.title
ORDER BY view_count DESC;

-- JOIN 쿼리용 [인기 콘텐츠 및 추천 조회] >> (3. 내가 본 장르 기반 추천) 다만 user_id=1임을 가정함.
SELECT DISTINCT c.title, g.genre_name
FROM Content c
JOIN ContentGenre cg ON c.content_id = cg.content_id
JOIN Genre g ON cg.genre_id = g.genre_id
WHERE g.genre_id IN (
    -- 내가 본 콘텐츠들의 장르 ID만 뽑아오는 서브쿼리
    SELECT cg2.genre_id 
    FROM WatchHistory wh
    JOIN PlatformContent pc ON wh.pc_id = pc.pc_id
    JOIN ContentGenre cg2 ON pc.content_id = cg2.content_id
    WHERE wh.user_id = 1  -- 현재 로그인한 유저 ID 예시
)
LIMIT 5;

-- [인기 콘텐츠 및 추천 조회] > (4. 플랫폼별 추천 콘텐츠 조회)
-- 특정 유저(user_id = 1)가 구독 중인 플랫폼의 콘텐츠만 조회
SELECT 
    u.username, 
    p.platform_name, 
    c.title, 
    pc.platform_rating
FROM Users u
JOIN UserSubscription us ON u.user_id = us.user_id
JOIN Platform p ON us.platform_id = p.platform_id
JOIN PlatformContent pc ON p.platform_id = pc.platform_id
JOIN Content c ON pc.content_id = c.content_id
WHERE u.user_id = 1 and pc.platform_rating>3.5
ORDER BY p.platform_name ASC, pc.platform_rating DESC;
