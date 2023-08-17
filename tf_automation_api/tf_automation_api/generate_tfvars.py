import os
from jinja2 import Environment, FileSystemLoader

cwd = os.path.dirname(os.path.realpath(__file__))
template_path = os.path.join(cwd,"..","templates")
print(template_path)

def loadTemplate(filepath, resource_type):
    """
    Load a template file.

    Args:
        filepath (str): The file path of the template file.
        resource_type (str): The type of the resource.

    Returns:
        Template: The loaded template object.
    """
    loader = FileSystemLoader(filepath) 
    environment = Environment(loader=loader)
    return environment.get_template(resource_type + "_template.tfvars") 

def generateTfvars(json_data, resource_type):
    """
    Generate tfvars content based on the provided JSON data and resource type.

    Args:
        json_data (dict): The JSON data to be rendered in the tfvars template.
        resource_type (str): The type of the resource.

    Returns:
        str: The generated tfvars content.
    """
    template = loadTemplate(template_path, resource_type)
    return template.render(json_data)
    
def createFile(content, resource_type):
    """
    Create a file and write the content into it.

    Args:
        content (str): The content to be written into the file.
        resource_type (str): The type of the resource.

    Returns:
        str: The filename of the created file.
    """
    filename = resource_type + '_generated.tfvars'
    with open(filename, 'w') as file:
        file.write(content)
    return filename
