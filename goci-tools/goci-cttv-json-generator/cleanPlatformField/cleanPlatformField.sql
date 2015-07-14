update study
set platform = 'Illumina [11,133,962] (Imputed)'
where platform = 'Ilumina [11,133,962] (Imputed)'

update study
set platform = 'Affymetrix [312,230]'
where platform = 'Affyemtrix [312,230]'

update study
set platform = 'Illumina [475,157]'
where platform = 'Ilumina [475,157]'

update study
set platform = 'Affymetrix [2,543,887] (imputed)'
where platform = 'Affymterix [2,543,887] (imputed)'


update study
set platform = 'Affymetrix [NR] (imputed)'
where platform = 'Affmyetrix [NR] (imputed)'


update study
set platform = 'Affymetrix [287,554]'
where platform = 'Afymetrix [287,554]'

update study
set platform = 'Affymetrix [561,137]'
where platform = 'Affmyetrix [561,137]'

update study
set platform = 'Affymetrix [661,736]'
where platform = 'Affyemtrix [661,736]'

update study
set platform = 'Illumina [NR]'
where platform = 'IlLumina [NR]'

update study
set platform = 'Perlegen [268,068]'
where platform = 'Perlgen [268,068]'



update study
set platform = 'Illumina [NR]'
where platform = 'Ilumina [NR]'


CREATE TABLE "GWAS"."ARRAY_INFO"
(
"ID" NUMBER(19,0) NOT NULL ENABLE,
"SNP_COUNT" NUMBER(19,0),
"IMPUTED" NUMBER (1) ,
"ARRAY_NAME" VARCHAR2(255 CHAR),
"SNP_COUNT_QUALIFIER" VARCHAR2(10 CHAR),
"PLATFORM" VARCHAR2(255 CHAR),
"POOLED" NUMBER (1) ,
"HAPLOTYPE_SNP_COUNT" NUMBER(19,0),
"SNP_PER_HAPLOTYPE_COUNT" NUMBER(19,0),
PRIMARY KEY ("ID"),
CONSTRAINT "PLATFORM_STUDY_ID_FK" FOREIGN KEY ("STUDY_ID")
	  REFERENCES "GWAS"."STUDY" ("ID") ENABLE
)

CREATE SEQUENCE  "GWAS"."S_GWASARRAY_INFO"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;

comment on table ARRAY_INFO is 'This is the table containing the information about the arrays used in the study'
comment on column ARRAY_INFO.ID is 'The unique id of the table'
comment on column ARRAY_INFO.SNP_COUNT is 'The number of snp genotyped with that array (including imputed is imputed is true)'
comment on column ARRAY_INFO.IMPUTED is '1 means true, 0 mean false. True if the snp were imputed, false if the snp_count represents solely the snp present on the array'
comment on column ARRAY_INFO.ARRAY_NAME is 'The manufacturer array name. It will not be used at first but maybe in the future'
comment on column ARRAY_INFO.SNP_COUNT_QUALIFIER is 'In the paper the author doesn’t always stipulates the exact number of snp but will say "more then 100000”, in that case, 100000 will be stored in the SNP_COUNT and more will be stored as “<“ in the SNP_COUNT_QUALIFIER'
comment on column ARRAY_INFO.PLATFORM is 'The name of the platforms used in the study  (ex : Affymetrix, Illumina…)'
comment on column ARRAY_INFO.POOLED is '1 if the dna samples where pooled together 0 if they were not. Nothing if we don not know'

alter table study
add array_info_id NUMBER(19,0)

ALTER TABLE STUDY
ADD CONSTRAINT STUDY_ARRAY_INFO_ID_FK
FOREIGN KEY (ARRAY_INFO_ID)
REFERENCES ARRAY_INFO(ID)

ALTER TABLE STUDY
ADD "PLATFORM_TRANSFERRED" NUMBER (1)

comment on column STUDY.PLATFORM_TRANSFERRED is '1 if data has been transferred to ARRAY_INFO table'



update study
set platform = 'Illumina [796,174]'
where platform = 'Illumina (796,174)'

update study
set platform = 'Affymetrix &'|| 'Illumina [~2.5 million] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.5 million} (imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [~2,800,000] (Imputed)'
where platform = 'Illumina &' || ' Affymetrix [~2,800,000s] (Imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [~2,400,000] Imputed'
where platform = 'Illumina &' || ' Affymetrix [~2,400,000s] Imputed'




update study
set platform = 'Illumina [544,590]'
where platform = 'Illumina [544,590}'

update study
set platform = 'Illumina [1,672,517] imputed'
where platform = 'Illumina (1,672,517) imputed'

update study
set platform = 'Illumina [625,739]'
where platform = 'Illumina (625,739)'

update study
set platform = 'Perlegen [429,901]'
where platform = 'Perlegen [429,901)'

update study
set platform = 'Affymetrix [455,089]'
where platform = 'Affymetrix (455,089)'

update study
set platform = 'Illumina &' || ' Affymetrix [~2.7 million] imputed'
where platform = 'Illumina &' || ' Affymetrix (~2.7 million) imputed'

update study
set platform = 'Illumina [565,404]'
where platform = 'Illumina (565,404)'

update study
set platform = 'Illumina [549,692]'
where platform = 'Illumina (549,692)'

update study
set platform = 'Illumina &' || ' Affymetrix [1,636,380] imputed'
where platform = 'Illumina &' || ' Affymetrix (1,636,380) imputed'

update study
set platform = 'Illumina [588,352]'
where platform = 'Illumina (588,352)'

update study
set platform = 'Illumina [565,404]'
where platform = 'Illumina (565,404)'

update study
set platform = 'Affymetrix &' || ' Illumina {~2.3 million] (imputed)'
where platform = 'Affymetrix &' || ' Illumina {~2.3 million] (imputed)'









update study
set platform = 'Illumina [~2,500,000] (Imputed)'
where platform = 'Illumina [~2.5 Million] (Imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [~1,000,000] (Imputed)'
where platform = 'Illumina &' || ' Affymetrix [~1 Million] (Imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,500,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.5 Million] (imputed)'

update study
set platform = 'Affymetrix [~2,500,000] (Imputed)'
where platform = 'Affymetrix [~2.5 Million] (Imputed)'

update study
set platform = 'NR [~2,500,000] (imputed)'
where platform = 'NR [~2.5 Million] (imputed)'

update study
set platform = 'Illumina [~ 2,500,000] (Imputed)'
where platform = 'Illumina [~ 2.5 Million] (Imputed)'

--CHECK
update study
set platform = 'Affymetrix [~2,500,000] (imputed)'
where platform = 'Affymetrix [~2.5 Million] (imputed)'

update study
set platform = 'Illumina [1,200,000] (Imputed)'
where platform = 'Illumina [1.2 Million] (Imputed)'

update study
set platform = 'Illumina [2,500,000] (Imputed)'
where platform = 'Illumina [2.5 Million] (Imputed)'

update study
set platform = 'Illumina [~2,000,000] (Imputed)'
where platform = 'Illumina [~2 Million] (Imputed)'

update study
set platform = 'Affymetrix [~2,200,000] (Imputed)'
where platform = 'Affymetrix [~2.2 Million] (Imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [~2,500,000] (imputed)'
where platform = 'Illumina &' || ' Affymetrix [~2.5 Million] (imputed)'

update study
set platform = 'Illumina and Affymetrix [~ 1,400,000] (imputed)'
where platform = 'Illumina and Affymetrix [~ 1.4 Million] (imputed)'

update study
set platform = 'Illumina, Affymetrix [~2,500,000] (Imputed)'
where platform = 'Illumina, Affymetrix [~2.5 Million] (Imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,500,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.5 Million] (imputed)'

update study
set platform = 'Illumina and Affymetrix [~ 2,000,000] (Imputed)'
where platform = 'Illumina and Affymetrix [~ 2 Million] (Imputed)'

update study
set platform = 'Illumina [~1,400,000]'
where platform = 'Illumina [~1.4 Million]'

update study
set platform = 'Illumina [1,200,000] (Imputed)'
where platform = 'Illumina [1.2 Million] (Imputed)'

update study
set platform = 'Affymetrix, Illumina and Perlegen [~2,600,000] (imputed)'
where platform = 'Affymetrix, Illumina and Perlegen [~2.6 Million] (imputed)'

update study
set platform = 'Illumina and Affymetrix [~2,400,000] (imputed)'
where platform = 'Illumina and Affymetrix [~2.4 Million] (imputed)'

update study
set platform = 'Illumina [>2,500,000] (imputed) '
where platform = 'Illumina [>2.5 Million] (imputed) '

update study
set platform = 'Illumina [>2,500,000] (imputed) '
where platform = 'Illumina [>2.5 Million] (imputed) '

update study
set platform = 'Illumina [~ 7 Million] (imputed)'
where platform = 'Illumina [~ 7 Million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [up to 2,200,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [up to 2.2 Million] (imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [~2,500,000] (imputed)'
where platform = 'Illumina &' || ' Affymetrix [~2.5 Million] (imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [~2,500,000] (imputed)'
where platform = 'Illumina &' || ' Affymetrix [~2.5 Million] (imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [~2,500,000] (imputed)'
where platform = 'Illumina &' || ' Affymetrix [~2.5 Million] (imputed)'

update study
set platform = 'Illumina [7,300,000] (imputed)'
where platform = 'Illumina [7.3 Million] (imputed)'

update study
set platform = 'Illumina and Affymetrix [up to 11,000,000] (imputed)'
where platform = 'Illumina and Affymetrix [up to 11 Million] (imputed)'

update study
set platform = 'Illumina [~2,500,000] (imputed)'
where platform = 'Illumina [~2.5 Million] (imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [~ 2,500,000] (imputed)'
where platform = 'Illumina &' || ' Affymetrix [~ 2.5 Million] (imputed)'

update study
set platform = 'Illumina [2,400,000] (imputed)'
where platform = 'Illumina [2.4 Million] (imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [up to 2,400,000] (imputed)'
where platform = 'Illumina &' || ' Affymetrix [up to 2.4 Million] (imputed)'

update study
set platform = 'Illumina [34,200,000] (imputed)'
where platform = 'Illumina [34.2 Million] (imputed)'

update study
set platform = 'Illumina [up to 2,400,000] (imputed)'
where platform = 'Illumina [up to 2.4 Million] (imputed)'

update study
set platform = 'Affymetrix [~17,000,000] (imputed)'
where platform = 'Affymetrix [~17 Million] (imputed)'

update study
set platform = 'Illumina and Affymetrix [~2,500,000] (imputed)'
where platform = 'Illumina and Affymetrix [~2.5 Million] (imputed)'

update study
set platform = 'Illumina [>1,000,000] (Imputed)'
where platform = 'Illumina [>1 Million] (Imputed)'

update study
set platform = 'Affymetrix [~5,200,000] (imputed)'
where platform = 'Affymetrix [~5.2 Million] (imputed)'

update study
set platform = 'Illumina [2,400,000] (imputed)'
where platform = 'Illumina [2.4 Million] (imputed)'

update study
set platform = 'Illumina [~2,500,000] (imputed)'
where platform = 'Illumina [~2.5 Million] (imputed)'

update study
set platform = 'Illumina [~7,000,000] (Imputed)'
where platform = 'Illumina [~7 Million] (Imputed)'

update study
set platform = 'Illumina [~ 7,000,000] (imputed)'
where platform = 'Illumina [~ 7 Million] (imputed)'


update study
set platform = 'Illumina [~2,500,000] (imputed)'
where platform = 'Illumina [~2.5 Million] (imputed)'

update study
set platform = 'Illumina [~2,500,000] (imputed)'
where platform = 'Illumina [~2.5 Million] (imputed)'

update study
set platform = 'NR [~2,700,000] (Imputed)'
where platform = 'NR [~2.7 Million] (Imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [~2,500,000] (imputed)'
where platform = 'Illumina &' || ' Affymetrix [~2.5 Million] (imputed)'

update study
set platform = 'Illumina and Affymetrix [~1,100,000] (imputed)'
where platform = 'Illumina and Affymetrix [~1.1 Million] (imputed)'

update study
set platform = 'Affymetrix, Illumina and Perlegen [at least ~ 2,500,000] (imputed)'
where platform = 'Affymetrix, Illumina and Perlegen [at least ~ 2.5 Million] (imputed)'

update study
set platform = 'Illumina and Affymetrix [~ 2,500,000] (imputed)'
where platform = 'Illumina and Affymetrix [~ 2.5 Million] (imputed)'

update study
set platform = 'Illumina and Affymetrix [~2,500,000] (imputed)'
where platform = 'Illumina and Affymetrix [~2.5 Million] (imputed)'

update study
set platform = 'Illumina [9,250,000] (imputed)'
where platform = 'Illumina [9.25 Million] (imputed)'

update study
set platform = 'Affymetrix and Illumina [~2,500,000] (imputed)'
where platform = 'Affymetrix and Illumina [~2.5 Million] (imputed)'

update study
set platform = 'Illumina [~2,500,000] (imputed)'
where platform = 'Illumina [~2.5 Million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~1,300,000]'
where platform = 'Affymetrix &' || ' Illumina [~1.3 Million]'

update study
set platform = 'Affymetrix &' || ' Illumina [up to 2,200,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [up to 2.2 Million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [up to 2,200,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [up to 2.2 Million] (imputed)'

update study
set platform = 'Affymetrix [~2,500,000] (imputed)'
where pubmed_id = 23275298













update study
set platform = 'Affymetrix &' || ' Illumina [~2,500,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.5 million] (imputed)'

update study
set platform = 'Affymetrix [2,500,000] (imputed)'
where platform = 'Affymetrix [2.5 million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,400,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.4 million] (imputed)'

update study
set platform = 'Illumina and Affymetrix [~2,500,000] (imputed)'
where platform = 'Illumina and Affymetrix [~2.5 million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,500,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.5 million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,560,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.56 million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,500,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.5 million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,500,000](imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.5 million](imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,500,000](imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.5 million](imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [~2,500,000] Imputed'
where platform = 'Illumina &' || ' Affymetrix [~2.5 million] Imputed'

update study
set platform = 'Afftmetrix &' || ' Illumina [~2,500,000] (imputed)'
where platform = 'Afftmetrix &' || ' Illumina [~2.5 million] (imputed)'

update study
set platform = 'Perlegen [~2,500,000] (imputed)'
where platform = 'Perlegen [~2.5 million] (imputed)'


update study
set platform = 'Affymetrix and Illumina [~2,500,000] (imputed)'
where platform = 'Affymetrix and Illumina [~2.5 million] (imputed)'

update study
set platform = 'Affymetrix [~1,800,000]'
where platform = 'Affymetrix [~1.8 million]'


update study
set platform = 'Affymetrix, Illumina &' || ' Perlegen [~2,500,000] (imputed)'
where platform = 'Affymetrix, Illumina &' || ' Perlegen [~2.5 million] (imputed)'

update study
set platform = 'Affymetrix, Illumina and Perlegen [~2,500,000] (imputed)'
where platform = 'Affymetrix, Illumina and Perlegen [~2.5 million] (imputed)'


update study
set platform = 'Affymetrix, Illumina &' || ' Perlegen [~2,600,000] (imputed)'
where platform = 'Affymetrix, Illumina &' || ' Perlegen [~2.6 million] (imputed)'

update study
set platform = 'Illumina [2,500,000] (imputed)'
where platform = 'Illumina [2.5 million] (imputed)'

update study
set platform = 'Illumina [~1,000,000] (imputed)'
where platform = 'Illumina [~1 million] (imputed)'

update study
set platform = 'Illumina [~2,740,000] (imputed)'
where platform = 'Illumina [~2.74 million] (imputed)'

update study
set platform = 'Illumina [~2,740,000] (imputed)'
where platform = 'Illumina [~2.74 million] (imputed)'

update study
set platform = 'Affymetrix, Illumina, and Perlegen [~2,500,000] (imputed)'
where platform = 'Affymetrix, Illumina, and Perlegen [~2.5 million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,200,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.2 million] (imputed)'


update study
set platform = 'Affymetrix &' || ' Illumina [~1,100,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [~1.1 million] (imputed)'


update study
set platform = 'Affymetrix [~2,500,000] (imputed)'
where platform = 'Affymetrix [~2.5 million] (imputed)'

update study
set platform = 'Illumina [~2,500,000] (imputed)'
where platform = 'Illumina [~2.5 million] (imputed)'



update study
set platform = 'Affymetrix [~2,740,000] (imputed)'
where platform = 'Affymetrix [~2.74 million] (imputed)'

update study
set platform = 'Affymetrix, Illumina &' || ' Perlgen [~2,500,000] (imputed)'
where platform = 'Affymetrix, Illumina &' || ' Perlgen [~2.5 million] (imputed)'


update study
set platform = 'Illumina [~2,380,000] (imputed)'
where platform = 'Illumina [~2.38 million] (imputed)'

update study
set platform = 'Affymetrix [~2 million] (Imputed)'
where platform = 'Affymetrix [~2 million] (Imputed)'



update study
set platform = 'Affymetrix [~1,400,000] (imputed)'
where platform = 'Affymetrix [~1.4 million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [1,700,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [1.7 million] (imputed)'


update study
set platform = 'Illumina [up to ~1,000,000] '
where platform = 'Illumina [up to ~1 million] '


update study
set platform = 'NR [~2,000,000]'
where platform = 'NR [~2 million]'



update study
set platform = 'Affymetrix &' || ' Illumina [~2,330,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.33 million] (imputed)'



update study
set platform = 'Affymetrix, Illumina and Perlegen [~2,100,000] (imputed)'
where platform = 'Affymetrix, Illumina and Perlegen [~2.1 million] (imputed)'



update study
set platform = 'Affymetrix &' || ' Illumina [>2,400,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [>2.4 million] (imputed)'



update study
set platform = 'Affymetrix [2,801,419 million] (imputed)'
where platform = 'Affymetrix [2,801,419 million] (imputed)'



update study
set platform = 'Affymetrix, Illumina &' || ' Perlegen [~1,400,000] (imputed)'
where platform = 'Affymetrix, Illumina &' || ' Perlegen [~1.4 million] (imputed)'


update study
set platform = 'Illumina [~2,300,000] (imputed)'
where platform = 'Illumina [~2.3 million] (imputed)'



update study
set platform = 'Illumina [5,000,000] (Imputed)'
where platform = 'Illumina [5 million] (Imputed)'


update study
set platform = 'Affymetrix &' || 'Illumina [~2,500,000] (imputed)'
where platform = 'Affymetrix &' || 'Illumina [~2.5 million] (imputed)'



update study
set platform = 'Affymetrix, Illumina &' || ' Perlgen [~2,600,000] (imputed)'
where platform = 'Affymetrix, Illumina &' || ' Perlgen [~2.6 million] (imputed)'


update study
set platform = 'Illumina &' || ' Affymetrix [1,200,000] (Imputed)'
where platform = 'Illumina &' || ' Affymetrix [1.2 million] (Imputed)'


update study
set platform = 'Illumina [~7,700,000] (imputed)'
where platform = 'Illumina [~7.7 million] (imputed)'

update study
set platform = 'Perlegen [2,400,000] (pooled)'
where pubmed_id = '17158188'

update study
set platform = 'Illumina [>2,500,000] (Imputed)'
where platform = 'Illumina [>2.5 million] (Imputed)'



update study
set platform = 'Affymetrix and Illumina [~2,110,000] (imputed)'
where platform = 'Affymetrix and Illumina [~2.11 million] (imputed)'


update study
set platform = 'Affymetrix and Perlegen [~1,600,000] (imputed)'
where platform = 'Affymetrix and Perlegen [~1.6 million] (imputed)'


update study
set platform = 'Illumina &' || ' Perlegen [~2,500,000] (imputed)'
where platform = 'Illumina &' || ' Perlegen [~2.5 million] (imputed)'


update study
set platform = 'Illumina &' || ' Affymetrix [~2,500,000] (imputed)'
where platform = 'Illumina &' || ' Affymetrix [~2.5 million] (imputed)'

update study
set platform = 'Illumina [~2,000,000] (imputed)'
where platform = 'Illumina [~2 million] (imputed)'


update study
set platform = 'Illumina [~2,600,000] (imputed)'
where platform = 'Illumina [~2.6 million] (imputed)'



update study
set platform = 'Illumina &' || ' Affymetrix [2,500,000] (Imputed)'
where platform = 'Illumina &' || ' Affymetrix [2.5 million] (Imputed)'

update study
set platform = 'Affymetrix [~2,200,000] (imputed)'
where platform = 'Affymetrix [~2.2 million] (imputed)'

update study
set platform = 'Affyemtrix &' || ' Illumina [~2,500,000] (imputed)'
where platform = 'Affyemtrix &' || ' Illumina [~2.5 million] (imputed)'

update study
set platform = 'Affymetrix [~2 million] (Imputed)'
where platform = 'Affymetrix [~2 million] (Imputed)'


update study
set platform = 'Affymetrix [2,801,419] (imputed)'
where platform = 'Affymetrix [2,801,419 million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [up to 2,500,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [up to 2.5 million] (imputed)'



update study
set platform = 'Illumina &' || ' Affymetrix [~2,800,000s] (Imputed)'
where platform = 'Illumina &' || ' Affymetrix [~2.8 millions] (Imputed)'



update study
set platform = 'Illumina [2,500,000] (Imputed)'
where platform = 'Illumina [2.5 million] (Imputed)'

update study
set platform = 'Affymetrix [1,900,000] (imputed)'
where platform = 'Affymetrix [1.9 million] (imputed)'

update study
set platform = 'Affymetrix, Illumina, and Perlegen (~2,440,000) [imputed]'
where platform = 'Affymetrix, Illumina, and Perlegen (~2.44 million) [imputed]'



update study
set platform = 'Affymetrix [~1,000,000]'
where platform = 'Affymetrix [~1 million]'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,900,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.9 million] (imputed)'

update study
set platform = 'Affymetrix, Illumina, and Perlegen [~2,600,000] (imputed)'
where platform = 'Affymetrix, Illumina, and Perlegen [~2.6 million] (imputed)'

update study
set platform = 'Illumina [2,600,000] (Imputed)'
where platform = 'Illumina [2.6 million] (Imputed)'

pdate study
set platform = 'Affymetrix &' || ' Illumina [~2,200,000](imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.2 million](imputed)'

update study
set platform = 'Affymetrix &' || ' Ilumina [~2,200,000] (imputed)'
where platform = 'Affymetrix &' || ' Ilumina [~2.2 million] (imputed)'

update study
set platform = 'Illumina [~2,400,000] (imputed)'
where platform = 'Illumina [~2.4 million] (imputed)'


update study
set platform = 'Illumina [~6,300,000] (imputed)'
where platform = 'Illumina [~6.3 million] (imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [~2,400,000s] Imputed'
where platform = 'Illumina &' || ' Affymetrix [~2.4 millions] Imputed'

update study
set platform = 'Illumina [~1,200,000] (imputed)'
where platform = 'Illumina [~1.2 million] (imputed)'

update study
set platform = 'Affymetrix [~2 million] (Imputed)'
where platform = 'Affymetrix [~2 million] (Imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [~2,600,000] (Imputed)'
where platform = 'Illumina &' || ' Affymetrix [~2.6 million] (Imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [2,500,000] (imputed)'
where platform = 'Illumina &' || ' Affymetrix [2.5 million] (imputed)'

update study
set platform = 'Affymetrix [2,500,000] (Imputed)'
where platform = 'Affymetrix [2.5 million] (Imputed)'

update study
set platform = 'Affymetrix, Illumina &' || ' Perlegen [~1,200,000](imputed)'
where platform = 'Affymetrix, Illumina &' || ' Perlegen [~1.2 million](imputed)'

update study
set platform = 'Affymetrix [~2,300,000] (imputed)'
where platform = 'Affymetrix [~2.3 million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [2,700,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [2.7 million] (imputed)'

update study
set platform = 'Illumina [>2,300,000] (imputed)'
where platform = 'Illumina [>2.3 million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,400,000] (Imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.4 million] (Imputed)'

update study
set platform = 'Illumina [~2,600,000] (Imputed)'
where platform = 'Illumina [~2.6 million] (Imputed)'

update study
set platform = 'Affymetrix [~3,700,000] (Imputed)'
where platform = 'Affymetrix [~3.7 million] (Imputed)'

update study
set platform = 'Illumina [~2,500,000](imputed)'
where platform = 'Illumina [~2.5 million](imputed)'

update study
set platform = 'Illumina [~16 million] (Imputed)'
where platform = 'Illumina [~16 million] (Imputed)'

update study
set platform = 'Affymetrix [~2,500,000] (Imputed)'
where platform = 'Affymetrix [~2.5 million] (Imputed)'


update study
set platform = 'Illumina &' || ' Affymetrix [2,800,000] (Imputed)'
where platform = 'Illumina &' || ' Affymetrix [2.8 million] (Imputed)'

update study
set platform = 'Affymetrix [~2 million] (Imputed)'
where platform = 'Affymetrix [~2 million] (Imputed)'

update study
set platform = 'Illumina [~16,000,000] (Imputed)'
where platform = 'Illumina [~16 million] (Imputed)'

update study
set platform = 'Affymetrix [>2,500,000] imputed'
where platform = 'Affymetrix [>2.5 million] imputed'

update study
set platform = 'Illumina [~7,200,000] (imputed)'
where platform = 'Illumina [~7.2 million] (imputed)'

update study
set platform = 'Affymetrix, Illumina and Perlegen [~2,800,000] (imputed)'
where platform = 'Affymetrix, Illumina and Perlegen [~2.8 million] (imputed)'



update study
set platform = 'Illumina [~2,500,000] (Imputed)'
where platform = 'Illumina [~2.5 million] (Imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,540,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.54 million] (imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [~8 million] Imputed'
where platform = 'Illumina &' || ' Affymetrix [~8 million] Imputed'

update study
set platform = 'Affyemtrix &' || ' Illumina [1,230,000] (imputed)'
where platform = 'Affyemtrix &' || ' Illumina [1.23 million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [1,230,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [1.23 million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [>2,500,000] (Imputed)'
where platform = 'Affymetrix &' || ' Illumina [>2.5 million] (Imputed)'

update study
set platform = 'Illumina [2,400,000] (Imputed)'
where platform = 'Illumina [2.4 million] (Imputed)'

update study
set platform = 'Affymetrix [~2,100,000] (imputed)'
where platform = 'Affymetrix [~2.1 million] (imputed)'

update study
set platform = 'Affymetrix [~5 million] (imputed)'
where platform = 'Affymetrix [~5 million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [3,200,000] Imputed'
where platform = 'Affymetrix &' || ' Illumina [3.2 million] Imputed'

update study
set platform = 'Illumina [~2,400,000] (Imputed)'
where platform = 'Illumina [~2.4 million] (Imputed)'

update study
set platform = 'Affmetrix &' || ' Illumina [~2,300,000] (Imputed)'
where platform = 'Affmetrix &' || ' Illumina [~2.3 million] (Imputed)'

update study
set platform = 'Affymetrix [~2 million] (Imputed)'
where platform = 'Affymetrix [~2 million] (Imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [~8 million] Imputed'
where platform = 'Illumina &' || ' Affymetrix [~8 million] Imputed'

update study
set platform = 'Affymetrix [~5 million] (imputed)'
where platform = 'Affymetrix [~5 million] (imputed)'

update study
set platform = '[~3 million] Imputed'
where platform = '[~3 million] Imputed'

update study
set platform = 'Illumina [2,300,000](imputed)'
where platform = 'Illumina [2.3 million](imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,600,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.6 million] (imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [>2,400,000](Imputed)'
where platform = 'Illumina &' || ' Affymetrix [>2.4 million](Imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,600,000](imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.6 million](imputed)'

update study
set platform = 'Affymetrix [up to 2,900,000] (imputed)'
where platform = 'Affymetrix [up to 2.9 million] (imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [2,700,000] (Imputed)'
where platform = 'Illumina &' || ' Affymetrix [2.7 million] (Imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,500,000] (Imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.5 million] (Imputed)'

update study
set platform = 'Affymetrix [~2 million] (Imputed)'
where platform = 'Affymetrix [~2 million] (Imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [~8 million] Imputed'
where platform = 'Illumina &' || ' Affymetrix [~8 million] Imputed'

update study
set platform = 'Affymetrix [~5 million] (imputed)'
where platform = 'Affymetrix [~5 million] (imputed)'

update study
set platform = '[~3 million] Imputed'
where platform = '[~3 million] Imputed'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,500,000] imputed'
where platform = 'Affymetrix &' || ' Illumina [~2.5 million] imputed'

update study
set platform = '[2,500,000] (Imputed)'
where platform = '[2.5 million] (Imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [>2,700,000] (Imputed)'
where platform = 'Illumina &' || ' Affymetrix [>2.7 million] (Imputed)'

update study
set platform = 'Illumina [1,300,000] (Imputed)'
where platform = 'Illumina [1.3 million] (Imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [up to 2,400,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [up to 2.4 million] (imputed)'

update study
set platform = 'Affymetrix [>2,500,000]'
where platform = 'Affymetrix [>2.5 million]'

update study
set platform = 'Affymetrix [1,700,000] (Imputed)'
where platform = 'Affymetrix [1.7 million] (Imputed)'

update study
set platform = 'Illumina [9,250,000] (Imputed)'
where platform = 'Illumina [9.25 million] (Imputed)'

update study
set platform = 'Illumina [~2,500,000]'
where platform = 'Illumina [~2.5 million]'

update study
set platform = 'Affymetrix and Illumina [2,500,000] (imputed)'
where platform = 'Affymetrix and Illumina [2.5 million] (imputed)'

update study
set platform = 'Illumina [> 2 million] (Imputed)'
where platform = 'Illumina [> 2 million] (Imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [>2,300,000] (Imputed)'
where platform = 'Illumina &' || ' Affymetrix [>2.3 million] (Imputed)'

update study
set platform = 'Illumina [34,200,000 (Imputed]'
where platform = 'Illumina [34.2 million (Imputed]'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,100,000] (Imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.1 million] (Imputed)'

update study
set platform = 'Illumina [~2,400,000] (pooled)'
where platform = 'Illumina [~2.4 million] (pooled)'

update study
set platform = 'Illumina [8,900,000] (Imputed)'
where platform = 'Illumina [8.9 million] (Imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [2,100,000] Imputed'
where platform = 'Illumina &' || ' Affymetrix [2.1 million] Imputed'

update study
set platform = 'Illumina [~1,400,000] (Imputed)'
where platform = 'Illumina [~1.4 million] (Imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [2,400,000] (imputed)'
where platform = 'Illumina &' || ' Affymetrix [2.4 million] (imputed)'

update study
set platform = 'Illumina [~1,400,000] (imputed)'
where platform = 'Illumina [~1.4 million] (imputed)'

update study
set platform = 'Affymetrix [~1,900,000] (imputed)'
where platform = 'Affymetrix [~1.9 million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [2,500,000] (Imputed)'
where platform = 'Affymetrix &' || ' Illumina [2.5 million] (Imputed)'

update study
set platform = 'Affymetrix [4,560,000] (imputed)'
where platform = 'Affymetrix [4.56 million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~1,300,000]'
where platform = 'Affymetrix &' || ' Illumina [~1.3 million]'

update study
set platform = 'Illumina [9,200,000] (Imputed)'
where platform = 'Illumina [9.2 million] (Imputed)'

update study
set platform = 'Illumina [30,600,000] (Imputed)'
where platform = 'Illumina [30.6 million] (Imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [~2,500,000] (Imputed)'
where platform = 'Illumina &' || ' Affymetrix [~2.5 million] (Imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [~2,700,000] imputed'
where platform = 'Illumina &' || ' Affymetrix [~2.7 million] imputed'




update study
set platform = 'Illumina and Affymetrix [~2,600,000] (Imputed)'
where platform = 'Illumina and Affymetrix [~2.6 million] (Imputed)'

update study
set platform = 'Illumina [~32,500,000] imputed'
where platform = 'Illumina [~32.5 million] imputed'

update study
set platform = 'NR [2,600,000] (imputed)'
where platform = 'NR [2.6 million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [>2,000,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [>2 million] (imputed)'

update study
set platform = 'Affymetrix and Illumina [~2,000,000] (imputed)'
where platform = 'Affymetrix and Illumina [~2 million] (imputed)'

update study
set platform = 'Illumina [~1,870,000]'
where platform = 'Illumina [~1.87 million]'

update study
set platform = 'Affymetrix and Illumina [~2,500,000] (Imputed)'
where platform = 'Affymetrix and Illumina [~2.5 million] (Imputed)'


update study
set platform = 'Affymetrix &' || ' Illumina [1,230,000](imputed)'
where platform = 'Affymetrix &' || ' Illumina [1.23 million](imputed)'

update study
set platform = 'Illumina [38,500,000] (imputed)'
where platform = 'Illumina [38.5 million] (imputed)'

update study
set platform = 'Illumina [~1,000,000]'
where platform = 'Illumina [~1 million]'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,500,000] Imputed'
where platform = 'Affymetrix &' || ' Illumina [~2.5 million] Imputed'

update study
set platform = 'Illumina &' || ' Affymetrix [2,100,000] Imputed'
where platform = 'Illumina &' || ' Affymetrix [2.1 million] Imputed'

update study
set platform = 'Illumina [2,300,000] (Imputed)'
where platform = 'Illumina [2.3 million] (Imputed)'



update study
set platform = '[~3,000,000] Imputed'
where platform = '[~3 million] Imputed'

update study
set platform = 'Affymetrix &' || ' Illumina [2,800,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [2.8 million] (imputed)'

update study
set platform = 'NR [>2,000,000] (imputed)'
where platform = 'NR [>2 million] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,420,000] (Imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.42 million] (Imputed)'

update study
set platform = 'Illumina and Affymetrix [>2,000,000] (Imputed)'
where platform = 'Illumina and Affymetrics [>2 million] (Imputed)'

update study
set platform = 'Illumina [~2,200,000] (imputed)'
where platform = 'Illumina [~2.2 million] (imputed)'


update study
set platform = 'Affymetrix [~2,000,000] (Imputed)'
where platform = 'Affymetrix [~2 million] (Imputed)'

update study
set platform = 'Illumina &' || ' Affymetrix [~8,000,000] Imputed'
where platform = 'Illumina &' || ' Affymetrix [~8 million] Imputed'

update study
set platform = 'Affymetrix [~5,000,000] (imputed)'
where platform = 'Affymetrix [~5 million] (imputed)'

update study
set platform = 'Illumina [> 2,000,000] (Imputed)'
where platform = 'Illumina [> 2 million] (Imputed)'


update study
set platform = 'Affymetrix &' || ' Illumina [~2,100,000] (Imputed)'
where platform = 'Affymetrx &' || ' Illumina [~2.1 milliion] (Imputed)'

update study
set platform = 'Illumina and Affymetrix [4,103,035] (imputed)'
where platform = 'Illumina and Affymterix [4,103,035] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,300,000] (Imputed)'
where platform = 'Affmetrix &' || ' Illumina [~2,300,000] (Imputed)'


update study
set platform = 'Affymetrix &' || ' Illumina [2,543,887] (imputed)'
where platform = 'Affmyetrix &' || ' Illumina [2,543,887] (imputed)'

update study
set platform = 'Illumina &' || ' Perlegen [465,816]'
where platform = 'Illumina &' || ' Perlgen [465,816]'

update study
set platform = 'Affymetrix &'|| ' Illumina [1,230,000] (imputed)'
where platform = 'Affyemtrix &' || ' Illumina [1,230,000] (imputed)'


update study
set platform = 'Affymetrix &' || ' Illumina [1,060,934] (imputed)'
where platform = 'Affyemtrix &' || ' Illumina [1,060,934] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [534,665]'
where platform = 'Affmyetrix &' || ' Illumina [534,665] '

update study
set platform = 'Affymetrix &' || ' Illumina [~2,200,000] (imputed)'
where platform = 'Affymetrix &' || ' Ilumina [~2,200,000] (imputed)'

update study
set platform = 'Affymetrix, Illumina &' || ' Perlegen [~2,600,000] (imputed)'
where platform = 'Affymetrix, Illumina &' || ' Perlgen [~2,600,000] (imputed)'

update study
set platform = 'Perlegen &' || ' Illumina [NR] (imputed)'
where platform = 'Perlgen &' || ' Illumina [NR] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~2.3 million] (imputed)'
where platform = 'Affymetrix &' || ' Illumina {~2.3 million] (imputed)'

update study
set platform = 'Affymetrix, Illumina &' || ' Perlegen [~2,500,000] (imputed)'
where platform = 'Affymetrix, Illumina &' || ' Perlgen [~2,500,000] (imputed)'

update study
set platform = 'Illumina, Affymetrix, Perlegen [up to 2,309,290] (Imputed)'
where platform = 'Illumina, Affymterix, Perlegen [up to 2,309,290] (Imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,500,000] (imputed)'
where platform = 'Affyemtrix &' || ' Illumina [~2,500,000] (imputed)'

update study
set platform = 'Affymetrix &' || ' Illumina [~2,500,000] (imputed)'
where platform = 'Afftmetrix &' || ' Illumina [~2,500,000] (imputed)'


update study
set platform = 'Affymetrix [469,218]'
where pubmed_id = '18449908'

update study
set platform = 'Affymetrix [386,731]'
where pubmed_id = '17463246'

update study
set platform = 'Illumina [up to 2,017,939]'
where pubmed_id = '25534755'

update study
set platform = 'Affymetrix &' || ' Perlegen [up to 727,905]'
where pubmed_id = '21752600'

update study
set platform = 'Affymetrix, Illumina, and Perlegen [~2,440,000] (imputed)'
where pubmed_id = '22982992'


update study
set platform = 'Illumina [315,917]'
where pubmed_id = '17668382'

update study
set platform = 'Affymetrix [88,500]'
where pubmed_id = '16648850'

update study
set platform = 'Illumina [314,075]'
where pubmed_id = '18455228'

update study
set platform = 'Illumina [317,501]'
where pubmed_id = '18204446'

update study
set platform = 'Illumina [304,250]'
where pubmed_id = '17690259'


update study
set platform = 'Illumina [308,015]'
where pubmed_id = '17767159'


update study
set platform = 'Illumina [555,235] (pooled)'
where pubmed_id = '17486107'


update study
set platform = 'Affymetrix [70,897]'
where pubmed_id = '17903307'

update study
set platform = 'Illumina [392,935]'
where pubmed_id = '17293876'


update study
set platform = 'Illumina [307,328]'
where pubmed_id = '17611496'


update study
set platform = 'NR [~80,000]'
where pubmed_id = '17653210'


update study
set platform = 'Affymetrix [66,543]'
where pubmed_id = '17848626'



update study
set platform = 'Affymetrix &' || ' Illumina [~2,300,000] (imputed)'
where platform = 'Affymetrix &' || ' Illumina [~2.3 million] (imputed)'


select platform, pubmed_id
from study
where  pubmed_id =  25035420

update study
set platform = 'NR [NR] (imputed)'
where pubmed_id = '24097068'

update study
set platform = 'Illumina [NR]'
where pubmed_id = '25200001'


update study
set platform = 'NR [NR]'
where pubmed_id = '23150908'


update study
set platform = 'Illumina  [NR]'
where pubmed_id = '25383971'


update study
set platform = 'NR  [NR]'
where pubmed_id = '22960999'

update study
set platform = 'Illumina [286,200]'
where pubmed_id = '20595679'



update study
set platform = 'Illumina [6,100,000] (imputed)'
where pubmed_id = '25015694'


update study
set platform = 'Illumina [293,913]'
where pubmed_id = '21886828'


update study
set platform = 'NR [NR]'
where pubmed_id = '21886828'


update study
set platform = 'NR [NR]'
where pubmed_id = '23307926'


update study
set platform = 'NR [NR]'
where pubmed_id = '22960999'


update study
set platform = 'NR [NR]'
where pubmed_id = '23496005'



update study
set platform = 'Affymetrix  [NR]'
where pubmed_id = '17554260'

update study
set platform = 'NR  [NR]'
where pubmed_id = '22693455'

update study
set platform = 'Affymetrix [UNSURE]'
where pubmed_id = '19388127'


update study
set platform = 'NR [NR]'
where pubmed_id = '22095909'


update study
set platform = 'Illumina [34,200,000] (Imputed)'
where platform = 'Illumina [34,200,000 (Imputed]'

update study
set platform = 'Illumina [313,179 SNPs; 339,846 2-SNP haplotypes]'
where pubmed_id = '17460697'


update study
set platform = 'Affymetrix [>371,951] (imputed)'
where platform = 'Affymetrix [more than 371,951] (imputed)'

update study
set platform = 'Illumina [>269,840] (imputed)'
where platform = 'Illumina [more than 269,840] (imputed)'