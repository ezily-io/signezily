# Security Groups Module

Module to select security groups, you must select one of the existing groups or modify the `locals.tf` to add one.

## Variables

* **vpc_name**: Name of the existing VPC, if not provided the default VPC will be selected. Example: ```my-vpc```
* **inbound**: Intranet inbound traffic, if not provided the default is empty. Example: ```Airbyte, Redash```
* **outbound**: Intranet outbound traffic, if not provided the default is empty. Example: ```Airbyte, Redash```
* **public_outbound**: Internet outbound traffic, if not provided the default is empty. Example: ```Airbyte, Redash```