Шаг 1:
1.1.
[mysqld]
server-id=1
log-bin=mysql-bin
gtid-mode=ON
enforce-gtid-consistency=ON

1.2. 
sudo systemctl restart mysql

1.3.
CREATE USER 'repl'@'%' IDENTIFIED BY 'password';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
FLUSH PRIVILEGES;

Шаг 2:
2.1.
[mysqld]
server-id=2
relay-log=mysql-relay-bin
log-slave-updates=1
read-only=1
gtid-mode=ON
enforce-gtid-consistency=ON

2.2.
sudo systemctl restart mysql

Шаг 3:
3.1.
SHOW MASTER STATUS;

3.2
CHANGE MASTER TO
MASTER_HOST='master_host_ip',
MASTER_USER='repl',
MASTER_PASSWORD='password',
MASTER_AUTO_POSITION=1;

3.3
START SLAVE;

3.4
SHOW SLAVE STATUS\G

Шаг 4:
4.1.
CREATE DATABASE testdb;
USE testdb;
CREATE TABLE test_table (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50));

4.2
INSERT INTO test_table (name) VALUES ('Alice'), ('Bob');

4.3
USE testdb;
SELECT * FROM test_table;

