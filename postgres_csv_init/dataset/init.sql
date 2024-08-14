-- 랜덤 문자열 생성용
CREATE OR REPLACE FUNCTION random_string(length INTEGER) RETURNS TEXT AS
$$
DECLARE
chars TEXT := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  result TEXT := '';
  i INTEGER := 0;
BEGIN
FOR i IN 1..length LOOP
    result := result || substr(chars, floor(random() * length(chars) + 1)::INTEGER, 1);
END LOOP;
RETURN result;
END;
$$ LANGUAGE plpgsql;

--배열로 랜던 문자를 반환
CREATE OR REPLACE FUNCTION generate_random_strings_array(textLength INTEGER, arrayLength INTEGER) RETURNS VARCHAR[] AS
$$
DECLARE
result VARCHAR[] := '{}';
    temp TEXT;
BEGIN
FOR i IN 1..arrayLength LOOP
        temp := random_string(textLength);
        result := array_append(result, temp);
END LOOP;
RETURN result;
END;
$$ LANGUAGE plpgsql;


-- 20개의 국가 이름을 반환하는 함수 생성
CREATE OR REPLACE FUNCTION random_country() RETURNS TEXT AS
$$
DECLARE
countries TEXT[] := ARRAY[
        'United States', 'Canada', 'Mexico', 'Brazil', 'Argentina',
        'United Kingdom', 'Germany', 'France', 'Italy', 'Spain',
        'China', 'Japan', 'South Korea', 'India', 'Australia',
        'South Africa', 'Egypt', 'Nigeria', 'Russia', 'Turkey'
    ];
    result TEXT;
BEGIN
    result := countries[floor(random() * array_length(countries, 1) + 1)::INTEGER];
RETURN result;
END;
$$ LANGUAGE plpgsql;

--랜덤한 고용형태  배열로 반환하는 함수 생성
CREATE OR REPLACE FUNCTION random_job_types() RETURNS VARCHAR[] AS
$$
DECLARE
job_types TEXT[] := ARRAY['PART_TIME', 'FULL_TIME', 'CONTRACT', 'INTERN', 'FREELANCER'];
    result VARCHAR[] := ARRAY[]::VARCHAR[];
    num_types INTEGER := floor(random() * 5 + 1);
    i INTEGER;
    random_index INTEGER;
BEGIN
FOR i IN 1..num_types LOOP
        random_index := floor(random() * array_length(job_types, 1) + 1)::INTEGER;
        result := array_append(result, job_types[random_index]);
        job_types := array_remove(job_types, job_types[random_index]);
END LOOP;
RETURN result;
END;
$$ LANGUAGE plpgsql;

--부모테이블  및 Array 타입 테스트용 테이블
CREATE TABLE recruit_desc (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    subject VARCHAR(200),
    recruit_count INT,
    area VARCHAR(20),
    tags VARCHAR[],
    hire_types VARCHAR[]
);

--tags 데이터의 정규형 테이블
CREATE TABLE recruit_tag (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    recruit_desc_id BIGINT,
    tag VARCHAR(20)
);
--hire_types 데이터의 정규형 테이블
CREATE TABLE recruit_hire_type (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    recruit_desc_id BIGINT,
    hire_type VARCHAR(20)
);

-- 데이터 삽입
INSERT INTO recruit_desc (subject, recruit_count, area, tags, hire_types)
SELECT
    random_string(20),
    floor(random() * 1000)::INTEGER,
    random_country(),
    generate_random_strings_array(10, 20),
    random_job_types()
FROM generate_series(1, 1000000);

--tags 데이터를 동일하게 자식 테이블로 셋팅 하여 입력합니다.
INSERT INTO recruit_tag (recruit_desc_id, tag)
SELECT r.id, unnest(r.tags)
FROM recruit_desc r;

--hire_types 데이터를 동일하게 자식 테이블로 셋팅 하여 입력합니다.
INSERT INTO recruit_hire_type (recruit_desc_id, hire_type)
SELECT r.id, unnest(r.hire_types)
FROM recruit_desc r;








