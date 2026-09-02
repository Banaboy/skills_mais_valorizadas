/*
As competênias mais procuradas no mercado. Para realizar
essa pesquisa agrupei os resultados por competências (skills)
e empregos em aberto
(contagem das linhas da tabela fato job_postings_fact)
┌─────────┬──────────────┐
│ procura │ competencias │
│  int64  │   varchar    │
├─────────┼──────────────┤
│   31428 │ sql          │
│   30902 │ python       │
│   19149 │ aws          │
│   15369 │ azure        │
│   13501 │ spark        │
│   10678 │ airflow      │
│    9512 │ snowflake    │
│    8933 │ databricks   │
│    7611 │ java         │
│    7161 │ gcp          │
├─────────┴──────────────┤
│ 10 rows      2 columns │
└────────────────────────┘
*/


SELECT
    COUNT(jpf.*) AS procura,
    sd.skills AS competencias
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
GROUP BY
    sd.skills
ORDER BY procura DESC
LIMIT 10;


