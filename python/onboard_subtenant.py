import requests


# only master tenant super users/admins should be able to run this successfully.
# you must have an api key created for the super user running this script. Morpheus will take care of the rest.

# API_KEY, HOST, and HEADERS variables. api key should automatically be pulled from the super user running the task/worflow.
API_KEY = morpheus['morpheus']['apiAccessToken']
HOST = morpheus['morpheus']['applianceHost']
HEADERS = {
    "content-type": "application/json",
    "accept": "application/json",
    "authorization": f"Bearer {API_KEY}",
    }

# subtenant variables
subten_name = morpheus['customOptions']['subtenName']
subten_domain = morpheus['customOptions']['subtenDomain']
subten_currency = morpheus['customOptions']['subtenCurrency']

# creates subtenant and returns tenant id which is used for creating admin user and groups within subtenant.
def create_subtenant():
    url = f"https://{HOST}/api/accounts"
    payload = {"account": {
        "role": {"id": 2},
        "name": subten_name,
        "subdomain": subten_domain,
        "currency": subten_currency
        }
    }
    response = requests.post(url=url, json=payload, HEADERS=HEADERS, verify=False)
    data = response.json()
    tenant_id = data['account']['id']
    return tenant_id

# subtenant admin user variables
# need to research second password input field to ensure correct password entered.
# also research password complextities and how to return ANY input field issues to user.
subten_admin_fname = morpheus['customOptions']['subtenAdminFirstName']
subten_admin_lname = morpheus['customOptions']['subtenAdminLastName']
subten_admin_uname = morpheus['customOptions']['subtenAdminUsername']
subten_admin_email = morpheus['customOptions']['subtenAdminEmail']
subten_admin_pw = morpheus['customOptions']['subtenAdminPw']
# second pw input field here??

# creates new admin user with role of JAmultitenant (from morpheus administration > roles)
def create_admin_user(tenant_id):
    url = f"https://{HOST}/api/accounts/{tenant_id}/users"
    payload = {
        "user": {"receiveNotifications": True,
        "roles": [{"id": 7}],
        "firstName": subten_admin_fname,
        "lastName": subten_admin_lname,
        "username": subten_admin_uname,
        "email": subten_admin_email,
        "password": subten_admin_pw
        }
    }
    response = requests.post(url=url, json=payload, HEADERS=HEADERS, verify=False)

# creates and gets admin user's access token
def get_admin_token():
    url = f"https://{HOST}/oauth/token?client_id=morph-api&grant_type=password&scope=write"
    payload = f"username={new_tenant_id}\\{subten_admin_uname}&password={subten_admin_pw}"
    call_header = {
        "accept": "application/json",
        "content-type": "application/x-www-form-urlencoded; charset=utf-8"
    }
    response = requests.post(url=url, data=payload, headers=call_header, verify=False)
    data = response.json()
    admin_token = data['access_token']
    return admin_token

# creates a default group within subtenant
def create_group(admin_token):
    url = f"https://{HOST}/api/accounts/{new_tenant_id}/groups"
    payload = {"group": {"name": "Default Group"}}
    call_header = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": f"Bearer {API_KEY}"
    }
    response = requests.post(url=url, json=payload, headers=call_header, verify=False)
    

new_tenant_id = create_subtenant()
new_admin_user = create_admin_user(new_tenant_id)
admin_token = get_admin_token()
create_group(admin_token)