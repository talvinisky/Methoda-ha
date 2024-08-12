pipeline {
    agent any

    stages {
        stage('Check for Merge to Master') {
            when {
                expression {
                    return env.GIT_BRANCH == 'origin/master' && currentBuild.changeSets.any {
                        it.getBranches().any { branch -> branch.name.contains('master') }
                    }
                }
            }
            steps {
                script {
                    def branchName = env.GIT_BRANCH
                    echo "Branch '${branchName}' merged into master."
                }
            }
        }

        stage('Move Jira Issue to Done') {
            steps {
                script {
                    // Extract Jira issue key from branch name
                    def branchName = env.GIT_BRANCH
                    def jiraKey = branchName =~ /([A-Z]+-\d+)/
                    if (jiraKey) {
                        echo "Jira Issue Key: ${jiraKey[0]}"
                        // Implement Jira API call to move the issue to Done
                        // Example: sh "curl -u username:token -X PUT -H 'Content-Type: application/json' -d '{\"transition\": {\"id\": \"31\"}}' https://your-jira-instance/rest/api/2/issue/${jiraKey[0]}/transitions"
                    }
                }
            }
        }
    }
}
