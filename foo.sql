SELECT t.name,
       tur.rating,
       count(f.id)
FROM tag_user_rating AS tur
JOIN fic AS f ON f.language_id = tur.tag_id
JOIN tag AS t ON tur.tag_id = t.id
WHERE tur.user_id = 1
GROUP BY t.name,
         tur.rating