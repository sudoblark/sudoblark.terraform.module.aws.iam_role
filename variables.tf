# Input variable definitions
variable "environment" {
  description = "Which environment this is being instantiated in."
  type        = string
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Must be either dev, test or prod"
  }
}

variable "application_name" {
  description = "Name of the application utilising resource."
  type        = string
}

variable "raw_iam_roles" {
  description = <<EOF

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

OPTIONAL
---------
- path                  : Path to create the role and policies under, defaults to "/"

- assume_policy_principles : A list of dictionaries where each dictionary defines a principle allowed to assume the role.
-- Each dictionary in this list must define the following attributes:
--- type          : A string defining what type the principle(s) is/are
--- identifiers   : A list of strings, where each string is an allowed principle
--- conditions    : An OPTIONAL list of dictionaries, which each defines:
---- test         : Test condition for limiting the action
---- variable     : Value to test
---- values       : A list of strings, denoting what to test for


Constraints
---------------
- <var.environment>-<var.application_name>-<suffix> has
to be lower than 38 characters due to IAM role naming requirements. Cannot encode in variable validation as
string interpolations are not allowed in variables.
EOF
  type = list(
    object({
      suffix = string,
      path   = optional(string, "/"),
      iam_policy_statements = list(
        object({
          sid       = string,
          actions   = list(string),
          resources = list(string),
          conditions = optional(list(
            object({
              test : string,
              variable : string,
              values = list(string)
            })
          ), [])
        })
      ),
      assume_policy_principles = optional(list(
        object({
          type        = string,
          identifiers = list(string),
          conditions = optional(list(
            object({
              test : string,
              variable : string,
              values = list(string)
            })
          ), [])
        })
      ), [])
    })
  )
}