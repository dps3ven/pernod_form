import yaml

def get_all_tenants():
    with open('renters.yml', 'r') as file:
        data = yaml.safe_load(file)
    return data['tenants']

def get_tenant_names():
    with open('renters.yml', 'r') as file:
        data = yaml.safe_load(file)
    return [tenant['name'] for tenant in data['tenants']]

def get_tenant_unit():
    with open('renters.yml', 'r') as file:
        data = yaml.safe_load(file)
    return [tenant['unit'] for tenant in data['tenants']]

if __name__ == "__main__":
    print(get_all_tenants())
    print(get_tenant_names())
    print(get_tenant_unit())