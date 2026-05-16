-- [내 시청 기록 관리]

-- 1. 본 콘텐츠 등록
INSERT INTO WatchHistory (
    user_id,
    pc_id,
    watch_status,
    watched_date
)
VALUES (
    ?, ?, ?, NOW()
);

-- Java preparedStatement 예시
-- PreparedStatement pstmt = conn.prepareStatement(sql);
-- pstmt.setInt(1, userId);
-- pstmt.setInt(2, pcId);
-- pstmt.setString(3, watchStatus);


-- 2. 내 시청 기록 조회
-- 내 시청 기록 조회는 사용자별 데이터 접근이 매우 빈번하므로
-- WatchHistory(user_id)에 인덱스를 생성하여
-- 전체 테이블 탐색을 줄이고 조회 성능을 향상시켰음.
CREATE INDEX idx_watchhistory_user_date
ON WatchHistory(user_id, watched_date);

SELECT
    c.title,
    p.platform_name,
    wh.watch_status,
    wh.watched_date
FROM WatchHistory wh
JOIN PlatformContent pc
    ON wh.pc_id = pc.pc_id
JOIN Content c
    ON pc.content_id = c.content_id
JOIN Platform p
    ON pc.platform_id = p.platform_id
WHERE wh.user_id = ?
ORDER BY wh.watched_date DESC;

-- 3. 시청 상태 수정
SELECT *
FROM WatchHistory; 
UPDATE WatchHistory
SET watch_status = ?
WHERE history_id = ?
AND user_id = ?;


-- 4. 시청 기록 삭제
DELETE FROM WatchHistory
WHERE history_id = ?
AND user_id = ?;


-- 0. 뒤로가기