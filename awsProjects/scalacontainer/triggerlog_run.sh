#!/bin/bash
echo -e "\n    Name  es" >> /etc/td-agent-bit/td-agent-bit.conf
echo "    Match *" >> /etc/td-agent-bit/td-agent-bit.conf
echo "    Port  9200" >> /etc/td-agent-bit/td-agent-bit.conf
echo "    Type  docker" >> /etc/td-agent-bit/td-agent-bit.conf
echo "    Host  143.244.151.181" >> /etc/td-agent-bit/td-agent-bit.conf
echo "    Index  executionstep_"$executionstepsid"_"$parallelid >> /etc/td-agent-bit/td-agent-bit.conf
echo "starting fluentd"
service td-agent-bit start -c  /etc/td-agent-bit/td-agent-bit.conf > /dev/null 2>&1 & 
echo "running code"
./run.sh > /usr/src/app/log/file.log 2>&1
cat /usr/src/app/log/file.log