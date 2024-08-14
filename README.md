# array column vs 정규화된 테이블 성능 테스트를 위한 테스트 데이터 생성

## Getting started


```base
cd postgres_csv_init
docker-compose up -d
```
테스트 데이터를 100만건 이상 생성하기에 init단계에서 PC성능에따라 3-10분 정도 이미지가 최종 실행되는 시간이 소요됩니다
참고 바랍니다!

### PG정보는 다음과 같이 설정되었습니다.

```
PG PORT : 7777
POSTGRES_PASSWORD=initexample
POSTGRES_USER=initexample
POSTGRES_HOST=postgres
POSTGRES_DB=initexample
```
