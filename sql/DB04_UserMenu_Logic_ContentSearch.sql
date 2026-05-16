-- [콘텐츠 검색 및 조회]

-- 1. 제목으로 콘텐츠 검색
SELECT * FROM v_content_detail 
WHERE 제목 LIKE ? 
ORDER BY 제목 ASC;

-- 자바 포인트: 
-- pstmt.setString(1, "%" + searchKeyword + "%"); 형태로 양쪽에 와일드카드를 붙여서 전달합니다.


-- 2. 장르별 콘텐츠 검색
SELECT * FROM v_content_detail 
WHERE 장르 = ? 
ORDER BY 평점 DESC;

-- 자바 포인트: pstmt.setString(1, selectedGenre);


-- 3. 콘텐츠 유형별 검색 (영화/드라마/예능/애니 등)
SELECT * FROM v_content_dev_content_detailv_content_detailtail 
WHERE 유형 = ? 
ORDER BY 제목 ASC;

-- 자바 포인트: pstmt.setString(1, typeName);


-- 4. 플랫폼별 콘텐츠 조회
SELECT * FROM v_content_detail 
WHERE 플랫폼 = ? 
ORDER BY 평점 DESC;

-- 자바 포인트: pstmt.setString(1, platformName);

-- 5. 콘텐츠 상세 정보 조회
SELECT * FROM v_content_detail 
WHERE content_id = ?;

-- 자바 코드 예시
-- String sql = "SELECT * FROM v_content_detail WHERE content_id = ?";
-- pstmt = conn.prepareStatement(sql);
-- pstmt.setInt(1, selectedId); // 사용자가 클릭한 콘텐츠의 ID
-- rs = pstmt.executeQuery();