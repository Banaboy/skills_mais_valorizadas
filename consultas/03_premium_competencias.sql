/* Notei que algumas vagas não possuiam média salarial. O COUNT(jpf.*) estava inflando os resultados.
Por isso alterei o contador para considerar apenas vagas onde salary_year_avg não fosse vazio (IS NOT NULL) .
Também notei que a curva das habilidades mais requisitadas se assemelhava muito ao logarítimo natural. Usei a função LN(COUNT(sjd.job_id)
para uma pontuação mais precisa. Decidi manter a pontuação_log * media_salarial como um parâmetro de comparação menos relevante.
full 2023–present dataset (refreshed monthly)

┌────────────┬────────────────┬─────────┬───────────────┬───────────────────┐
│   skills   │ media_salarial │ demanda │ pontuação_log │ pontuação_simples │
│  varchar   │     double     │  int64  │    double     │      double       │
├────────────┼────────────────┼─────────┼───────────────┼───────────────────┤
│ python     │       135000.0 │    1133 │           7.0 │               9.0 │
│ sql        │       130000.0 │    1128 │           7.0 │               9.0 │
│ aws        │       137320.3 │     783 │           6.7 │               9.0 │
│ spark      │       140000.0 │     503 │           6.2 │               9.0 │
│ azure      │       128000.0 │     475 │           6.2 │               8.0 │
│ snowflake  │       135500.0 │     438 │           6.1 │               8.0 │
│ airflow    │       150000.0 │     386 │           6.0 │               9.0 │
│ java       │       135000.0 │     303 │           5.7 │               8.0 │
│ kafka      │       145000.0 │     292 │           5.7 │               8.0 │
│ databricks │       132750.0 │     266 │           5.6 │               7.0 │
│ redshift   │       130000.0 │     274 │           5.6 │               7.0 │
│ scala      │       137290.5 │     247 │           5.5 │               8.0 │
│ nosql      │       134415.0 │     193 │           5.3 │               7.0 │
│ terraform  │       184000.0 │     193 │           5.3 │              10.0 │
│ hadoop     │       135000.0 │     198 │           5.3 │               7.0 │
│ gcp        │       136000.0 │     196 │           5.3 │               7.0 │
│ git        │       140000.0 │     208 │           5.3 │               7.0 │
│ tableau    │       115000.0 │     164 │           5.1 │               6.0 │
│ kubernetes │       150500.0 │     147 │           5.0 │               8.0 │
│ docker     │       135000.0 │     144 │           5.0 │               7.0 │
│ pyspark    │       140000.0 │     152 │           5.0 │               7.0 │
│ sql server │       120000.0 │     139 │           4.9 │               6.0 │
│ r          │       134775.0 │     133 │           4.9 │               7.0 │
│ power bi   │       120000.0 │     129 │           4.9 │               6.0 │
│ postgresql │       122500.0 │     129 │           4.9 │               6.0 │
├────────────┴────────────────┴─────────┴───────────────┴───────────────────┤
│ 25 rows                                                         5 columns │
└───────────────────────────────────────────────────────────────────────────┘
*/

SELECT 
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 1) AS media_salarial,
    COUNT(sjd.job_id) AS demanda,
    ROUND(LN(COUNT(sjd.job_id)), 1) AS pontuação_log,
    ROUND((pontuação_log * media_salarial)/100_000) AS pontuação_simples
FROM job_postings_fact jpf
INNER JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.salary_year_avg IS NOT NULL
    AND jpf.job_work_from_home = True 
GROUP BY
    sd.skills
HAVING 
    COUNT(sjd.job_id) >= 100
ORDER BY
    pontuação_log DESC
LIMIT 25;

