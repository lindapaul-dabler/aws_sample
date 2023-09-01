import boto3
import os
import git 
import shutil

print("copying files")
pipelineid =  os.environ['pipelineid']
pipelinename = os.environ['pipelinename']
stepid =  os.environ['stepid']
stepname = os.environ['stepname']
GIT_USERNAME = os.environ['GIT_USERNAME'] 
GIT_PASSWORD = os.environ['GIT_PASSWORD']
repopath = os.environ['repopath']
repourl = f"https://{GIT_USERNAME}:{GIT_PASSWORD}@{repopath}"

executepath = f"/root/repo"
localRepopath = f"/root/tmprepo"
repo = git.Repo.clone_from(repourl, localRepopath)

shutil.copytree(f'{localRepopath}/{stepname}', executepath)