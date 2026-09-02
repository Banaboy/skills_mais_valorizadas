/*
Competências mais bem pagas no mercado. Aqui a aplicação seguiu uma consulta bem intuitiva: Apenas competências
a partir de 100 vagas ou mais. Ordenado da skill mais requisitada para a menor. ao lado do valor pago para cada competência.
Para fazer essa consulta foi preciso fazer algumas junções (JOIN) entre a tabela fato job_postings_fact e duas tabelas dimensionais
┌─────────────┬────────────────┬────────────┐
│ competência │ media_salarial │ quantidade │
│   varchar   │     double     │   int64    │
├─────────────┼────────────────┼────────────┤
│ terraform   │       184000.0 │        193 │
│ kubernetes  │       150500.0 │        147 │
│ airflow     │       150000.0 │        386 │
│ kafka       │       145000.0 │        292 │
│ git         │       140000.0 │        208 │
│ go          │       140000.0 │        113 │
│ spark       │       140000.0 │        503 │
│ pyspark     │       140000.0 │        152 │
│ aws         │       137320.0 │        783 │
│ scala       │       137290.0 │        247 │
│ gcp         │       136000.0 │        196 │
│ mongodb     │       135750.0 │        136 │
│ snowflake   │       135500.0 │        438 │
│ docker      │       135000.0 │        144 │
│ github      │       135000.0 │        127 │
│ python      │       135000.0 │       1133 │
│ hadoop      │       135000.0 │        198 │
│ java        │       135000.0 │        303 │
│ bigquery    │       135000.0 │        123 │
│ r           │       134775.0 │        133 │
│ nosql       │       134415.0 │        193 │
│ databricks  │       132750.0 │        266 │
│ mysql       │       130500.0 │        101 │
│ sql         │       130000.0 │       1128 │
│ redshift    │       130000.0 │        274 │
├─────────────┴────────────────┴────────────┤
│ 25 rows                         3 columns │
└───────────────────────────────────────────┘
*/

SELECT 
    sd.skills AS competência,
    ROUND(MEDIAN(jpf.salary_year_avg)) AS media_salarial,
    COUNT(sd.skills) AS quantidade
FROM
    job_postings_fact AS jpf
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
    HAVING COUNT(sd.skills) > 100
ORDER BY
    media_salarial DESC
LIMIT 25;