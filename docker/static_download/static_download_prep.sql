CREATE LANGUAGE plpgsql;

CREATE FUNCTION string_agg_transfn(text, text, text)
    RETURNS text AS 
    $$
        BEGIN
            IF $1 IS NULL THEN
                RETURN $2;
            ELSE
                RETURN $1 || $3 || $2;
            END IF;
        END;
    $$
    LANGUAGE plpgsql IMMUTABLE
COST 1;

CREATE AGGREGATE string_agg(text, text) (
    SFUNC=string_agg_transfn,
    STYPE=text
);

CREATE TEMPORARY TABLE pre_literature_long AS
select sample_id, regexp_replace(literatures.short_citation||', '||literatures_samples.pages, ', $', '') as short_ref 
from literatures_samples 
LEFT JOIN literatures ON literatures_samples.literature_id = literatures.id;

CREATE TEMPORARY TABLE pre_literature_wide AS
SELECT sample_id, string_agg(short_ref, '; ') as short_ref
FROM pre_literature_long
GROUP BY sample_id
order by sample_id;

CREATE TEMPORARY TABLE radoni AS
  SELECT
  samples.id AS "ID"
  , labs.lab_code||'-'||samples.lab_nr AS "LABNR"
  , samples.bp AS "C14AGE"
  , samples.std AS "C14STD"
  , samples.delta_13_c AS "C13"
  , prmats.name AS "MATERIAL"
  , samples.prmat_comment AS "SPECIES"
  , countries.name AS "COUNTRY"
  , sites.name AS "SITE"
  , cultures.name AS "CULTURE"
  , phases.name AS "PERIOD"
  , feature_types.name AS "FEATURETYPE"
  , feature AS "FEATURE"
  , sites.lat AS "LATITUDE"
  , sites.lng AS "LONGITUDE"
  , pre_literature_wide.short_ref AS "REFERENCE"
  FROM samples
  LEFT JOIN labs ON samples.lab_id = labs.id
  LEFT JOIN prmats ON samples.prmat_id = prmats.id
  LEFT JOIN sites ON samples.site_id = sites.id
  LEFT JOIN country_subdivisions ON sites.country_subdivision_id =
country_subdivisions.id
  LEFT JOIN countries ON country_id = countries.id
  LEFT JOIN phases ON samples.phase_id = phases.id
  LEFT JOIN cultures ON phases.culture_id = cultures.id
  LEFT JOIN feature_types ON samples.feature_type_id = feature_types.id
  LEFT JOIN pre_literature_wide ON samples.id = pre_literature_wide.sample_id
  WHERE samples.right_id=1;

UPDATE radoni
SET "MATERIAL" = regexp_replace("MATERIAL", E'[\\n\\r]+', ' ', 'g' );
UPDATE radoni
SET "SPECIES" = regexp_replace("SPECIES", E'[\\n\\r]+', ' ', 'g' );
UPDATE radoni
SET "COUNTRY" = regexp_replace("COUNTRY", E'[\\n\\r]+', ' ', 'g' );
UPDATE radoni
SET "SITE" = regexp_replace("SITE", E'[\\n\\r]+', ' ', 'g' );
UPDATE radoni
SET "CULTURE" = regexp_replace("CULTURE", E'[\\n\\r]+', ' ', 'g' );
UPDATE radoni
SET "PERIOD" = regexp_replace("PERIOD", E'[\\n\\r]+', ' ', 'g' );
UPDATE radoni
SET "FEATURETYPE" = regexp_replace("FEATURETYPE", E'[\\n\\r]+', ' ', 'g' );
UPDATE radoni
SET "FEATURE" = regexp_replace("FEATURE", E'[\\n\\r]+', ' ', 'g' );
UPDATE radoni
SET "REFERENCE" = regexp_replace("REFERENCE", E'[\\n\\r]+', ' ', 'g' );

select * from radoni;
