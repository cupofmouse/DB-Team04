-- [내 리뷰 및 평점 관리]
CREATE INDEX idx_review_user
ON Review(user_id);

CREATE INDEX idx_review_pc
ON Review(pc_id);

CREATE INDEX idx_review_rating
ON Review(rating);

CREATE VIEW v_review_detail AS
SELECT
    r.review_id,
    u.username,
    c.title,
    p.platform_name,
    r.rating,
    r.review_text,
    r.review_date,
    r.is_spoiler
FROM Review r
JOIN Users u
    ON r.user_id = u.user_id
JOIN PlatformContent pc
    ON r.pc_id = pc.pc_id
JOIN Content c
    ON pc.content_id = c.content_id
JOIN Platform p
    ON pc.platform_id = p.platform_id;
    
-- 1. 리뷰 및 평점 작성
INSERT INTO Review (
    user_id,
    pc_id,
    rating,
    review_text,
    review_date,
    is_spoiler
)
VALUES (
    ?, ?, ?, ?, NOW(), ?
);

-- 2. 내 리뷰 조회

SELECT
    review_id,
    title,
    platform_name,
    rating,
    review_text,
    review_date,
    is_spoiler
FROM v_review_detail
WHERE username = ?
ORDER BY review_date DESC;

-- 3. 콘텐츠별 리뷰 조회
SELECT
    username,
    rating,
    review_text,
    review_date,
    is_spoiler
FROM v_review_detail
WHERE title = ?
ORDER BY review_date DESC;

-- 4. 리뷰 수정
UPDATE Review
SET
    rating = ?,
    review_text = ?,
    is_spoiler = ?
WHERE review_id = ?
AND user_id = ?;

-- 5. 리뷰 삭제
DELETE FROM Review
WHERE review_id = ?
AND user_id = ?;

-- 6. 시청 완료 및 리뷰 작성
-- 1) WatchHistory 상태 변경
UPDATE WatchHistory
SET
    watch_status = 'COMPLETED',
    watched_date = NOW()
WHERE user_id = ?
AND pc_id = ?;
-- 2) Review 작성
INSERT INTO Review (
    user_id,
    pc_id,
    rating,
    review_text,
    review_date,
    is_spoiler
)
VALUES (
    ?, ?, ?, ?, NOW(), ?
);
-- 3) 둘 다 성공 시 COMMIT
-- 4) 실패 시 ROLLBACK



-- 0. 뒤로가기