#!/bin/bash
EXECUTEPATH="/root/repo"
LOCALREPOPATH="/root/tmprepo"
echo "Dabler: Downloading code repo."
REPOURL="https://$GIT_USERNAME:$GIT_PASSWORD@$repopath"

# Download the Repo
if git clone $REPOURL $LOCALREPOPATH; then
  echo "Dabler: Code repo download completed succesfully."
else
  echo "Dabler: Error in code repo download."
  amqp-publish --uri="amqp://dabuser:dabcredentials4u@35.178.99.22:5672/" --exchange="" --routing-key="task_queue" --body="{\"action\":\"FAILED\",\"pipelineid\":$pipelineid,\"stepid\":$stepid,\"executionid\":$executionid,\"executionstepsid\":$executionstepsid,\"onerroraction\":\"$onerroraction\",\"parallelism\":$parallelism}"
  sleep 6
  exit 1
fi

# Copy the repo folder for the step and cd to that folder
mv $LOCALREPOPATH/$stepid $EXECUTEPATH
cd $EXECUTEPATH

# Install packages
echo "Dabler: Installing packages from requirements.txt"
if apt-get install -r requirements.txt; then
	echo "Dabler: Library install completed succesfully."
else
	echo "Dabler: Error in library install."
fi

# Execute the code from entry point
echo "Dabler: Executing code from entry point <$entrypoint>"
if python "$EXECUTEPATH/$entrypoint"; then 
	echo "Dabler: Task execution completed succesfully." 
    amqp-publish --uri="amqp://dabuser:dabcredentials4u@35.178.99.22:5672/" --exchange="" --routing-key="task_queue" --body="{\"action\":\"SUCCESS\",\"pipelineid\":$pipelineid,\"stepid\":$stepid,\"executionid\":$executionid,\"executionstepsid\":$executionstepsid,\"onerroraction\":\"$onerroraction\",\"parallelism\":$parallelism}"
else
	echo "Dabler: Error in task execution."
    amqp-publish --uri="amqp://dabuser:dabcredentials4u@35.178.99.22:5672/" --exchange="" --routing-key="task_queue" --body="{\"action\":\"FAILED\",\"pipelineid\":$pipelineid,\"stepid\":$stepid,\"executionid\":$executionid,\"executionstepsid\":$executionstepsid,\"onerroraction\":\"$onerroraction\",\"parallelism\":$parallelism}"
	sleep 6
	exit 1
fi
sleep 6