SELECT DISTINCT
    fic.id,
    ca.rating + wa.rating + ra.rating + au.rating + fa.rating + ch.rating + re.rating + ad.rating AS weight,
    fic.link
FROM
    fic
    INNER JOIN category_fic AS ca_f ON fic.id = ca_f.fic_id
    INNER JOIN warning_fic AS wa_f ON fic.id = wa_f.fic_id
    INNER JOIN fandom_fic AS fa_f ON fic.id = fa_f.fic_id
    INNER JOIN character_fic AS ch_f ON fic.id = ch_f.fic_id
    INNER JOIN relationship_fic AS re_f ON fic.id = re_f.fic_id
    INNER JOIN additional_fic AS ad_f ON fic.id = ad_f.fic_id
    INNER JOIN category AS ca ON ca_f.category_id = ca.id
    INNER JOIN warning AS wa ON wa_f.warning_id = wa.id
    INNER JOIN fandom AS fa ON fa_f.fandom_id = fa.id
    INNER JOIN character AS ch ON ch_f.character_id = ch.id
    INNER JOIN relationship AS re ON re_f.relationship_id = re.id
    INNER JOIN additional AS ad ON ad_f.additional_id = ad.id
    INNER JOIN rating AS ra ON fic.rating_id = ra.id
    INNER JOIN author AS au ON fic.author_id = au.id
WHERE
    ca.rating + wa.rating + ra.rating + au.rating + fa.rating + ch.rating + re.rating + ad.rating > 0
ORDER BY
    weight DESC
