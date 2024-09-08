#!/bin/bash

# Load Jira URL, username, and API token from secrets.sh
source ./secrets.sh

# Sample environment variable (you can set this manually or from a CI system)
GIT_BRANCH="feature/PROJECT-123-some-feature"

# Extract Jira issue key from the branch name
jiraKey=$(echo $GIT_BRANCH | grep -oE "([A-Z]+-[0-9]+)") # We assume in this instance that there is only one jira issue in the branch

if [ -n "$jiraKey" ]; then
    echo "Jira Issue Key: $jiraKey"

    # Retrieve the available transitions for the Jira issue
    transitionsResponse=$(curl -s -u "$JIRA_USERNAME:$JIRA_API_TOKEN" -X GET \
        -H "Accept: application/json" \
        "$JIRA_URL/issue/$jiraKey/transitions")

    # Parse the response to find the transition ID for 'Done'
    doneTransitionId=$(echo "$transitionsResponse" | jq -r '.transitions[] | select(.name == "Done") | .id')

    if [ -n "$doneTransitionId" ]; then
        echo "Found 'Done' transition ID: $doneTransitionId"

        # Use the 'Done' transition ID to move the issue to 'Done'
        curl -s -u "$JIRA_USERNAME:$JIRA_API_TOKEN" -X POST \
            -H "Content-Type: application/json" \
            -d "{\"transition\": {\"id\": \"$doneTransitionId\"}}" \
            "$JIRA_URL/issue/$jiraKey/transitions"

        echo "Issue $jiraKey has been moved to 'Done'."
    else
        echo "Error: Could not find 'Done' transition for the Jira issue."
        exit 1
    fi
else
    echo "Error: Jira issue key not found in branch name."
    exit 1
fi
