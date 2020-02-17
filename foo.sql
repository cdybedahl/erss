CREATE OR REPLACE VIEW fic_user_ratings AS
SELECT tf.fic_id,
       r.user_id,
       sum(r.rating) AS total
FROM tag_fic AS tf
JOIN rating AS r ON tf.tag_id = r.tag_id
GROUP BY (tf.fic_id,
          r.user_id)