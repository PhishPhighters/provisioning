# Collaboration
# Script Name:                  Email Setup
# Author:                       David Morgan 
# Date of latest revision:      11/15/2023
# Purpose:                      to connect email client to the users email
# Execution:			        Individual commands on powershell or powershell -

# Documentation   
import requests
import json

# Define the necessary credentials and parameters
tenant_id = 'd851935a-e0f3-4447-b696-f1ede71b0ac3'
client_id = 'eca009c7-43d9-4d57-8435-557df0c3575c'
client_secret = '642e3aff-f8cd-40e0-bd74-708bff2f45c7'

# Obtain an access token using client credentials flow
token_url = f'https://login.microsoftonline.com/{tenant_id}/oauth2/v2.0/token'
token_data = {
    'client_id': client_id,
    'scope': 'https://graph.microsoft.com/.default',
    'client_secret': client_secret,
    'grant_type': 'client_credentials'
}

token_r = requests.post(token_url, data=token_data)
access_token = token_r.json()['access_token']

# Create a user using Microsoft Graph API
create_user_url = 'https://graph.microsoft.com/v1.0/users'

headers = {
    'Authorization': 'Bearer ' + access_token,
    'Content-Type': 'application/json'
}

user_payload = {
    'accountEnabled': True,
    'displayName': 'Squirrelly Rabbits',
    'mailNickname': 'squirrellyrabbits',
    'userPrincipalName': 'Squirrellyrabbits@outlook.com',  # Replace with user details
    'passwordProfile': {
        'forceChangePasswordNextSignIn': True,
        'password': 'Phishey1!' 
    }
}

response = requests.post(create_user_url, headers=headers, json=user_payload)

if response.status_code == 201:
    print('User created successfully.')
else:
    print('Failed to create user:', response.text)