—- Which era has the albums I’m most sentimentally attached to
SELECT 
  CASE 
    WHEN release_year < 1980 THEN 'Classic (pre-1980)'
    WHEN release_year < 1997 THEN 'Vintage (1980s-1997)'
    WHEN release_year < 2010 THEN 'Childhood nostalgia (1997-2010)'
    WHEN release_year < 2017 THEN 'High school and college (roughly 2010-2016)'
    ELSE 'Modern (2017 and later)'
  END as era,
  COUNT(*) as albums,
  COUNT(CASE WHEN sentimental_value = 'high' THEN 1 END) as deeply_loved
FROM albums
GROUP BY 1
ORDER BY albums DESC;


—- Which broader genres hit me emotionally vs which are just “good music”
SELECT genre_umbrella,
       COUNT(*) as total,
       COUNT(CASE WHEN sentimental_value = 'high' THEN 1 END) as high_sentiment, 
       ROUND(COUNT(CASE WHEN sentimental_value = 'high' THEN 1 END) * 100.0 / COUNT(*), 1) as 
emotional_hit_rate
FROM albums
GROUP BY genre_umbrella
HAVING COUNT(*) >= 3
ORDER BY emotional_hit_rate DESC;



-- Which specific genres hit me emotionally vs which are just "good music"
SELECT genre,
       COUNT(*) as total,
       COUNT(CASE WHEN sentimental_value = 'high' THEN 1 END) as high_sentiment,
       ROUND(COUNT(CASE WHEN sentimental_value = 'high' THEN 1 END) * 100.0 / COUNT(*), 1) as 
emotional_hit_rate
FROM albums
GROUP BY genre
HAVING COUNT(*) >= 3
ORDER BY emotional_hit_rate DESC
LIMIT 10;


—- Which years have the most releases I enjoyed
SELECT release_year, COUNT(*) AS total_albums
FROM albums
GROUP BY release_year
ORDER BY total_albums DESC
LIMIT 10;


—- Which decades do I have the most favorite releases
SELECT decade, COUNT(*) AS total_albums
FROM albums
GROUP BY decade
ORDER BY total_albums DESC;


—- How do my favorite genres change by release decade (taste for 90s grunge morphing into 2010s 
rap, etc)
SELECT decade, genre_umbrella, COUNT(*) as albums,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
FROM albums 
GROUP BY decade, genre_umbrella
ORDER BY decade, albums DESC;


—- What are the shortest and longest albums by genre umbrella
WITH genre_stats AS (
  SELECT genre_umbrella, 
         AVG(CAST(SPLIT_PART(length, ':', 1) AS INTEGER) + 
             CAST(SPLIT_PART(length, ':', 2) AS INTEGER) / 60.0) as avg_length,
         STDDEV(CAST(SPLIT_PART(length, ':', 1) AS INTEGER) + 
                CAST(SPLIT_PART(length, ':', 2) AS INTEGER) / 60.0) as std_length
  FROM albums GROUP BY genre_umbrella
),
outliers AS (
  SELECT a.album_title, a.artist, a.genre_umbrella,
         ROUND(CAST(SPLIT_PART(a.length, ':', 1) AS INTEGER) + 
               CAST(SPLIT_PART(a.length, ':', 2) AS INTEGER) / 60.0, 1) as length_minutes,
         ROUND(gs.avg_length, 1) as avg_length,
         (CAST(SPLIT_PART(a.length, ':', 1) AS INTEGER) + 
          CAST(SPLIT_PART(a.length, ':', 2) AS INTEGER) / 60.0) - gs.avg_length as length_diff,
         ROW_NUMBER() OVER (PARTITION BY a.genre_umbrella ORDER BY 
           (CAST(SPLIT_PART(a.length, ':', 1) AS INTEGER) + 
            CAST(SPLIT_PART(a.length, ':', 2) AS INTEGER) / 60.0) DESC) as longest_rank,
         ROW_NUMBER() OVER (PARTITION BY a.genre_umbrella ORDER BY 
           (CAST(SPLIT_PART(a.length, ':', 1) AS INTEGER) + 
            CAST(SPLIT_PART(a.length, ':', 2) AS INTEGER) / 60.0) ASC) as shortest_rank
  FROM albums a
  JOIN genre_stats gs ON a.genre_umbrella = gs.genre_umbrella
)
SELECT album_title, artist, genre_umbrella, length_minutes, avg_length,
       CASE WHEN longest_rank = 1 THEN 'LONGEST' 
            WHEN shortest_rank = 1 THEN 'SHORTEST' END as outlier_type
FROM outliers
WHERE longest_rank = 1 OR shortest_rank = 1
ORDER BY genre_umbrella, outlier_type DESC;


—- Which season has more albums that I am sentimentally attached to
SELECT season,
       COUNT(*) as total_albums,
       COUNT(CASE WHEN sentimental_value = 'high' THEN 1 END) as high_sentiment, 
       COUNT(CASE WHEN sentimental_value = 'medium' THEN 1 END) as medium_sentiment,
       COUNT(CASE WHEN sentimental_value = 'low' THEN 1 END) as low_sentiment,
       ROUND(COUNT(CASE WHEN sentimental_value = 'high' THEN 1 END) * 100.0 / COUNT(*), 1) as 
emotional_hit_rate
FROM albums
WHERE season != 'any'
GROUP BY season
ORDER BY emotional_hit_rate DESC;

