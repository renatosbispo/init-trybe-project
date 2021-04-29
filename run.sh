#!/bin/bash

# Current default prefix for the projects' repositories:
PROJECT_REPOSITORY_PREFIX="sd-0"

# Get user input:
read -p "Sua turma (exemplo: 11, sem o zero): " COHORT
read -p "Nome do projeto (exemplo: pixels-art): " PROJECT
read -p "Prefixo do nome da sua branch (exemplo: gabrieloliva): " STUDENT_BRANCH_PREFIX
read -p "Seu usuário no GitHub (exemplo: caabeatriz): " GITHUB_USERNAME
read -p "Seu token de acesso: " ACCESS_TOKEN
read -p "Título do seu PR: " PR_TITLE
read -p "Nome do branch principal do projeto (exemplo: main): " MAIN_BRANCH_NAME
read -p "Método para clonar o repositório: (1) SSH  (2) HTTP " CLONE_METHOD

# Build the project's repository name:
PROJECT_REPOSITORY="$PROJECT_REPOSITORY_PREFIX""$COHORT""-project-""$PROJECT"

# Clone the repository:
if [ "$CLONE_METHOD" -eq "1" ]
then
  echo "[INIT TRYBE PROJECT] Cloning project repository with SSH..."
  $SHELL -c "git clone git@github.com:tryber/"$PROJECT_REPOSITORY".git"
else
  echo "[INIT TRYBE PROJECT] Cloning project repository with HTTPS..."
  $SHELL -c "git clone https://github.com/tryber/"$PROJECT_REPOSITORY".git"
fi

# Setup the project:
STUDENT_BRANCH_NAME="$STUDENT_BRANCH_PREFIX""-project-""$PROJECT"
cd "$PROJECT_REPOSITORY"

# Create branch and checkout:
$SHELL -c "git checkout -b "$STUDENT_BRANCH_NAME""

# Run npm install:
echo "[INIT TRYBE PROJECT] Running npm install..."
$SHELL -c "npm install"

# Git add, commit and push:
$SHELL -c "git add -A"
$SHELL -c "git commit -m 'Auto commit by https://github.com/renatosbispo/init-trybe-project: finish project setup'"
echo "[INIT TRYBE PROJECT] Running git push..."
$SHELL -c "git push -u origin "$STUDENT_BRANCH_NAME""

# Create Pull Request:
echo "[INIT TRYBE PROJECT] Creating Pull Request..."
PR_ENDPOINT="https://api.github.com/repos/tryber/"$PROJECT_REPOSITORY"/pulls"
PR_PARAMETERS='{"title":"'"$PR_TITLE"'","head":"'"$STUDENT_BRANCH_NAME"'","base":"'"$MAIN_BRANCH_NAME"'"}'
curl -u "$GITHUB_USERNAME":"$ACCESS_TOKEN" -X POST -H "Accept: application/vnd.github.v3+json" "$PR_ENDPOINT" -d "$PR_PARAMETERS"

exit
