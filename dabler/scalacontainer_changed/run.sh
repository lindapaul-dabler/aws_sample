#!/bin/bash
EXECUTEPATH="/root/repo"
LOCALREPOPATH="/root/tmprepo"
echo "Dabler: Downloading code repo."
REPOURL="https://$sf_GIT_USERNAME:$sf_GIT_PASSWORD@$sf_repopath"

# Download the Repo
if git clone $REPOURL $LOCALREPOPATH; then
  echo "Dabler: Code repo download completed succesfully."
else
  echo "Dabler: Error in code repo download."
  amqp-publish --uri="amqp://dabuser:dabcredentials4u@35.178.99.22:5672/" --exchange="" --routing-key="task_queue" --body="{\"action\":\"FAILED\",\"pipelineid\":$sf_pipelineid,\"stepid\":$sf_stepid,\"executionid\":$sf_executionid,\"executionstepsid\":$sf_executionstepsid,\"onerroraction\":\"$sf_onerroraction\",\"parallelism\":$sf_parallelism}"
  sleep 6
  exit 1
fi

# Copy the repo folder for the step and cd to that folder
mv $LOCALREPOPATH/$sf_stepid $EXECUTEPATH
cd $EXECUTEPATH


# Install packages from list
echo "Dabler: Installing packages"
export IFS=";"
if [ -z "$sf_library" ] ;
then
echo "Dabler: no libraries to install."
else 
libraries=$sf_library
for library in $libraries; do
  	echo "Installing package $library"
  	if apt install $library ; then
		echo "Dabler: Library install $library completed."
	else
		echo "Dabler: Error in library install: $library."
	fi
done
fi

# Install packages from requirements.txt
if [ -f "requirements.txt" ] ; then
echo "Dabler: Installing packages from requirements.txt"
if apt install -r requirements.txt ; then
	echo "Dabler: Library install completed succesfully."
else
	echo "Dabler: Error in library install."
fi
fi
#Compiling the code from entry point
echo "Dabler: compiling code from entry point <$sf_entrypoint>"
if scalac "$EXECUTEPATH/$sf_entrypoint"; then 
    
	echo "Dabler: Task compilation completed succesfully." 
   amqp-publish --uri="amqp://dabuser:dabcredentials4u@35.178.99.22:5672/" --exchange="" --routing-key="task_queue" --body="{\"action\":\"SUCCESS\",\"pipelineid\":$sf_pipelineid,\"stepid\":$sf_stepid,\"executionid\":$sf_executionid,\"executionstepsid\":$sf_executionstepsid,\"onerroraction\":\"$sf_onerroraction\",\"parallelism\":$sf_parallelism}"
else
	echo "Dabler: Error in task compiling."
    amqp-publish --uri="amqp://dabuser:dabcredentials4u@35.178.99.22:5672/" --exchange="" --routing-key="task_queue" --body="{\"action\":\"FAILED\",\"pipelineid\":$sf_pipelineid,\"stepid\":$sf_stepid,\"executionid\":$sf_executionid,\"executionstepsid\":$sf_executionstepsid,\"onerroraction\":\"$sf_onerroraction\",\"parallelism\":$sf_parallelism}"
	sleep 6
	exit 1
fi
# Executing the code from entry point
echo "Dabler: Executing code from entry point <$sf_entrypoint>"
filename="${sf_entrypoint%.*}"
#echo $filename
if scala "$filename"; then 
	echo "Dabler: Task execution completed succesfully." 
    amqp-publish --uri="amqp://dabuser:dabcredentials4u@35.178.99.22:5672/" --exchange="" --routing-key="task_queue" --body="{\"action\":\"SUCCESS\",\"pipelineid\":$sf_pipelineid,\"stepid\":$sf_stepid,\"executionid\":$sf_executionid,\"executionstepsid\":$sf_executionstepsid,\"onerroraction\":\"$sf_onerroraction\",\"parallelism\":$sf_parallelism}"
else
	echo "Dabler: Error in task execution."
    amqp-publish --uri="amqp://dabuser:dabcredentials4u@35.178.99.22:5672/" --exchange="" --routing-key="task_queue" --body="{\"action\":\"FAILED\",\"pipelineid\":$sf_pipelineid,\"stepid\":$sf_stepid,\"executionid\":$sf_executionid,\"executionstepsid\":$sf_executionstepsid,\"onerroraction\":\"$sf_onerroraction\",\"parallelism\":$sf_parallelism}"
	sleep 6
	exit 1
fi
sleep 6