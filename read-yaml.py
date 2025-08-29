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

def verify_tenant(email, unit, phone):
    status = False
    with open('tenants.yml', 'r') as file:
        data = yaml.safe_load(file)
    
    for tenant in data['tenants']:
        if (tenant['email'] == email and 
            tenant['unit'] == unit and 
            tenant['phone'] == phone):
            status = True
    return status

if __name__ == "__main__":
    download_tenant_yaml()
    result = (verify_tenant("owners@vindotllc","5069A", "(217) 520-1212"))
    if result == True:
        print("Forward to LLC")
    else:
        print("Please revist your form input.")
    # print(call_amazon_api("XXX", "XXXXX"))