# sudoblark.terraform.module.aws.iam_role
Terraform module to create N number of IAM roles. - repo managed by sudoblark.terraform.github

## Developer documentation
The below documentation is intended to assist a developer with interacting with the Terraform module in order to add,
remove or update functionality.

### Pre-requisites
* terraform_docs

```sh
brew install terraform_docs
```

* tfenv
```sh
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
```

* Virtual environment with pre-commit installed

```sh
python3 -m venv venv
source venv/bin/activate
pip install pre-commit
```
### Pre-commit hooks
This repository utilises pre-commit in order to ensure a base level of quality on every commit. The hooks
may be installed as follows:

```sh
source venv/bin/activate
pip install pre-commit
pre-commit install
pre-commit run --all-files
```

# Module documentation
The below documentation is intended to assist users in utilising the module, the main thing to note is the
[data structure](#data-structure) section which outlines the interface by which users are expected to interact with
the module itself, and the [examples](#examples) section which has examples of how to utilise the module.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.61.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.67.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_policy_document.assume_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.attached_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | Name of the application utilising resource. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Which environment this is being instantiated in. | `string` | n/a | yes |
| <a name="input_raw_iam_roles"></a> [raw\_iam\_roles](#input\_raw\_iam\_roles) | Data structure<br>---------------<br>A list of dictionaries, where each dictionary has the following attributes:<br><br>REQUIRED<br>---------<br>- suffix                : Suffix to use for the role name<br>- iam\_policy\_statements : A list of dictionaries where each dictionary is an IAM statement defining permissions<br>-- Each dictionary in this list must define the following attributes:<br>--- sid: Friendly name for the policy, no spaces or special characters allowed<br>--- actions: A list of IAM actions the role is allowed to perform<br>--- resources: Which resource(s) the role may perform the above actions against<br>--- conditions    : An OPTIONAL list of dictionaries, which each defines:<br>---- test         : Test condition for limiting the action<br>---- variable     : Value to test<br>---- values       : A list of strings, denoting what to test for<br><br>- assume\_policy\_principles : A list of dictionaries where each dictionary defines a principle allowed to assume the role.<br>-- Each dictionary in this list must define the following attributes:<br>--- type          : A string defining what type the principle(s) is/are<br>--- identifiers   : A list of strings, where each string is an allowed principle<br>--- conditions    : An OPTIONAL list of dictionaries, which each defines:<br>---- test         : Test condition for limiting the action<br>---- variable     : Value to test<br>---- values       : A list of strings, denoting what to test for<br><br>OPTIONAL<br>---------<br>- path                  : Path to create the role and policies under, defaults to "/"<br><br>Constraints<br>---------------<br>- <var.environment>-<var.application\_name>-<suffix> has<br>to be lower than 38 characters due to IAM role naming requirements. Cannot encode in variable validation as<br>string interpolations are not allowed in variables. | <pre>list(<br>    object({<br>      suffix = string,<br>      path   = optional(string, "/"),<br>      iam_policy_statements = list(<br>        object({<br>          sid       = string,<br>          actions   = list(string),<br>          resources = list(string),<br>          conditions = optional(list(<br>            object({<br>              test : string,<br>              variable : string,<br>              values = list(string)<br>            })<br>          ), [])<br>        })<br>      ),<br>      assume_policy_principles = list(<br>        object({<br>          type        = string,<br>          identifiers = list(string),<br>          conditions = optional(list(<br>            object({<br>              test : string,<br>              variable : string,<br>              values = list(string)<br>            })<br>          ), [])<br>        })<br>      )<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Data structure
```
Data structure
---------------
A list of dictionaries, where each dictionary has the following attributes:

REQUIRED
---------
- suffix                : Suffix to use for the role name
- iam_policy_statements : A list of dictionaries where each dictionary is an IAM statement defining permissions
-- Each dictionary in this list must define the following attributes:
--- sid: Friendly name for the policy, no spaces or special characters allowed
--- actions: A list of IAM actions the role is allowed to perform
--- resources: Which resource(s) the role may perform the above actions against
--- conditions    : An OPTIONAL list of dictionaries, which each defines:
---- test         : Test condition for limiting the action
---- variable     : Value to test
---- values       : A list of strings, denoting what to test for

- assume_policy_principles : A list of dictionaries where each dictionary defines a principle allowed to assume the role.
-- Each dictionary in this list must define the following attributes:
--- type          : A string defining what type the principle(s) is/are
--- identifiers   : A list of strings, where each string is an allowed principle
--- conditions    : An OPTIONAL list of dictionaries, which each defines:
---- test         : Test condition for limiting the action
---- variable     : Value to test
---- values       : A list of strings, denoting what to test for

OPTIONAL
---------
- path                  : Path to create the role and policies under, defaults to "/"

Constraints
---------------
- <var.environment>-<var.application_name>-<suffix> has
to be lower than 38 characters due to IAM role naming requirements. Cannot encode in variable validation as
string interpolations are not allowed in variables.
```

## Examples
See `examples` folder for an example setup.
