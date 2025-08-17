import yaml
import requests
import boto3

def download_tenant_yaml():
    s3 = boto3.client('s3')
    s3.download_file("vindot-llc-tenants", "tenants.yml", "tenants.yml")

# def get_all_tenants():
#     with open('renters.yml', 'r') as file:
#         data = yaml.safe_load(file)
#     return data['tenants']

# def get_tenant_names():
#     with open('renters.yml', 'r') as file:
#         data = yaml.safe_load(file)
#     return [tenant['name'] for tenant in data['tenants']]

# def get_tenant_unit():
#     with open('renters.yml', 'r') as file:
#         data = yaml.safe_load(file)
#     return [tenant['unit'] for tenant in data['tenants']]

def verify_tenant(name, unit, phone):
    status = False
    with open('tenants.yml', 'r') as file:
        data = yaml.safe_load(file)
    
    for tenant in data['tenants']:
        if (tenant['name'].lower() == name.lower() and 
            tenant['unit'] == unit and 
            tenant['phone'] == phone):
            status = True
    return status

# def call_amazon_api(name, unit):
#     if verify_tenant(name, unit):
#         url = "https://3b7196t76h.execute-api.us-east-2.amazonaws.com/dev/"
#         response = requests.post(url)
#         return response.json()
#     return None

if __name__ == "__main__":
    download_tenant_yaml()
    # print(get_all_tenants())
    # print(get_tenant_names())
    # print(get_tenant_unit())
    # print(verify_tenant("Paco Greenwell", "5069B", "555-0456"))
    # print(verify_tenant("Pinko Greenwell", "5069B", "555-0456"))
    result = (verify_tenant("Paci Greenwell", "5069B", "555-0456"))
    if result == True:
        print("Forward to LLC")
    else:
        print("Rejected")
    # print(call_amazon_api("XXX", "XXXXX"))