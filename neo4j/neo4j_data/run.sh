docker rm -f rasa_neo4j
docker run  -d \
--name rasa_neo4j   \
-v /mnt/e/ENOCH-2022/RASA/Rasa_neo4j/neo4j/neo4j_data/data:/data  \
-v /mnt/e/ENOCH-2022/RASA/Rasa_neo4j/neo4j/neo4j_data/log:/logs  \
-v /mnt/e/ENOCH-2022/RASA/Rasa_neo4j/neo4j/neo4j_data/conf:/var/lib/neo4j/conf  \
-v /mnt/e/ENOCH-2022/RASA/Rasa_neo4j/neo4j/neo4j_data/import:/var/lib/neo4j/import \
--env=NEO4J_AUTH=none  \
--publish=7474:7474  \
--restart=always  \
--publish=7687:7687 neo4j:4.1
