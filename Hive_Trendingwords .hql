mysql -u nuvvu001 -p5199994 -h msba6320.oit.umn.edu twitter_ferguson

sqoop import \
--connect jdbc:mysql://msba6320.oit.umn.edu/twitter_ferguson \
--username nuvvu001 \
--password 5199994 \
--fields-terminated-by '\t' \
--table tweets \
--hive-import

hadoop fs -cat /user/hive/warehouse/tweets/part* | head -n 5

SELECT explode(ngrams(SENTENCES(LOWER(tweet_text)), 2, 25))
AS bigrams
FROM tweets;

CREATE table trendingwords (word1 STRING, word2 STRING, estfreq double) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

INSERT OVERWRITE table trendingwords SELECT x.bigrams.ngram[0],x.bigrams.ngram[1],x.bigrams.estfrequency 
from (SELECT EXPLODE(NGRAMS(SENTENCES(LOWER(tweet_text)), 2, 1000)) 
AS bigrams FROM tweets) x;

SELECT * from trendingwords where word1 like '%ferguson%' or word2 like'%ferguson%';