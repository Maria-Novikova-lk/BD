Шаг 1:
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:percona/testing
sudo apt-get update
sudo apt-get install percona-xtradb-cluster-57

Шаг 2:
Node1
[mysqld]
server-id=1
wsrep_cluster_name="my_cluster"
wsrep_cluster_address="gcomm://node1_ip,node2_ip,node3_ip"
wsrep_node_address="node1_ip"
wsrep_node_name="node1"
wsrep_sst_method=rsync
wsrep_sst_auth=sstuser:sstpass

Node2
[mysqld]
server-id=2
wsrep_cluster_name="my_cluster"
wsrep_cluster_address="gcomm://node1_ip,node2_ip,node3_ip"
wsrep_node_address="node2_ip"
wsrep_node_name="node2"
wsrep_sst_method=rsync
wsrep_sst_auth=sstuser:sstpass

Node3
[mysqld]
server-id=3
wsrep_cluster_name="my_cluster"
wsrep_cluster_address="gcomm://node1_ip,node2_ip,node3_ip"
wsrep_node_address="node3_ip"
wsrep_node_name="node3"
wsrep_sst_method=rsync
wsrep_sst_auth=sstuser:sstpass

Шаг 3:
CREATE USER 'sstuser'@'localhost' IDENTIFIED BY 'sstpass';
GRANT RELOAD, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'sstuser'@'localhost';
FLUSH PRIVILEGES;

Шаг 4:
4.1
sudo systemctl start mysql@bootstrap-pxc
4.2
sudo systemctl start mysql

Шаг 5:
mysql -u root -p -e "SHOW STATUS LIKE 'wsrep_cluster_size';"
mysql -u root -p -e "SHOW STATUS LIKE 'wsrep_local_state_comment';"

Шаг 6:
CREATE DATABASE testdb;
USE testdb;
CREATE TABLE testtable (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255));
INSERT INTO testtable (name) VALUES ('Alice'), ('Bob'), ('Charlie');

Шаг 7:
USE testdb;
SHOW TABLES;
SELECT COUNT(*) FROM testtable;


