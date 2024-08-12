#!/bin/bash

# Set Jira and Confluence URLs
JIRA_URL="http://jira.example.com"
CONFLUENCE_URL="http://confluence.example.com"

# Jira admin credentials
JIRA_USER="jira_admin"
JIRA_PASS="jira_password"

# Confluence admin credentials
CONFLUENCE_USER="confluence_admin"
CONFLUENCE_PASS="confluence_password"

# Create application link in Jira to Confluence
echo "Creating application link in Jira to Confluence..."
curl -u $JIRA_USER:$JIRA_PASS \
     -X POST \
     -H "Content-Type: application/json" \
     -d '{
            "applicationName": "Confluence",
            "applicationType": "Confluence",
            "adminURL": "'"$CONFLUENCE_URL"'",
            "displayURL": "'"$CONFLUENCE_URL"'",
            "rpcURL": "'"$CONFLUENCE_URL"'",
            "sharedSecret": "your_shared_secret"
         }' \
     $JIRA_URL/rest/applinks/1.0/applicationlinkForm/createApplicationLink

echo "Application link created in Jira."

# Create application link in Confluence to Jira
echo "Creating application link in Confluence to Jira..."
curl -u $CONFLUENCE_USER:$CONFLUENCE_PASS \
     -X POST \
     -H "Content-Type: application/json" \
     -d '{
            "applicationName": "Jira",
            "applicationType": "Jira",
            "adminURL": "'"$JIRA_URL"'",
            "displayURL": "'"$JIRA_URL"'",
            "rpcURL": "'"$JIRA_URL"'",
            "sharedSecret": "your_shared_secret"
         }' \
     $CONFLUENCE_URL/rest/applinks/1.0/applicationlinkForm/createApplicationLink

echo "Application link created in Confluence."
