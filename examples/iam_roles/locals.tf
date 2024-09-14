locals {
  raw_iam_roles = [
    {
      suffix = "redshift-role",
      iam_policy_statements = [
        {
          sid    = "AllowListGlueBuckets"
          effect = "Allow"
          actions = [
            "s3:ListBucket",
            "s3:GetBucketAcl"
          ]
          resources = [
            "arn:aws:s3:::raw-bucket",
            "arn:aws:s3:::processed-bucket"
          ]
        },
        {
          sid    = "AllowGlueBucketObjectManipulation"
          effect = "Allow"
          actions = [
            "s3:GetObject",
            "s3:PutObject"
          ]
          resources = [
            "arn:aws:s3:::raw-bucket/*",
            "arn:aws:s3:::processed-bucket/*"
          ]
        },
        {
          sid    = "AllowGlueTableAccess"
          effect = "Allow"
          actions = [
            "glue:SearchTables",
            "glue:GetDatabase",
            "glue:GetTableVersion",
            "glue:GetTables",
            "glue:GetTableVersions",
            "glue:GetDatabases",
            "glue:GetTable",
            "glue:BatchGetPartition",
            "glue:GetPartitions"
          ]
          resources = [
            "arn:aws:glue:${data.aws_region.current_region.name}:${data.aws_caller_identity.current_account.account_id}:table/*/*",
            "arn:aws:glue:${data.aws_region.current_region.name}:${data.aws_caller_identity.current_account.account_id}:catalog",
            "arn:aws:glue:${data.aws_region.current_region.name}:${data.aws_caller_identity.current_account.account_id}:database/*"
          ]
        },
        {
          sid    = "AllowDescribeOwnStatements"
          effect = "Allow"
          actions = [
            "redshift-data:DescribeStatement"
          ]
          resources = [
            "*"
          ]
        }
      ]
    },
    {
      suffix = "sagemaker-executor",
      iam_policy_statements = [
        {
          sid     = "AllowIAMPassRoleToSageMakerExecutionRole"
          effect  = "Allow"
          actions = ["iam:PassRole"]
          resources = [
            "arn:aws:iam::${data.aws_caller_identity.current_account.account_id}:role/aws-${var.environment}-${var.application_name}-sagemaker-executor*"
          ]
          conditions : [
            {
              test     = "StringEquals"
              variable = "iam:PassedToService"
              values   = ["sagemaker.amazonaws.com"]
            }
          ]
        },
        {
          sid     = "AllowReadOnlyS3BucketGetObjectToSageMakerExecutionRole"
          effect  = "Allow"
          actions = ["s3:GetObject"]
          resources = [
            "arn:aws:s3:::${var.environment}-${var.application_name}-example-export-bucket/*",
            "arn:aws:s3::${var.environment}-${var.application_name}-example-artefact-bucket/*",
            "arn:aws:s3:::${var.environment}-${var.application_name}-example-output-bucket/*"
          ]
        },
        {
          sid     = "AllowReadOnlyS3ListBucketToSageMakerExecutionRole"
          effect  = "Allow"
          actions = ["s3:ListBucket"]
          resources = [
            "arn:aws:s3:::-${var.environment}-${var.application_name}-example-export-bucket",
            "arn:aws:s3:::-${var.environment}-${var.application_name}-example-artefact-bucket",
            "arn:aws:s3:::-${var.environment}-${var.application_name}-example-output-bucket"
          ]
        },
        {
          sid    = "AllowReadWriteAccessFor${title(var.environment)}S3Bucket"
          effect = "Allow"
          actions = [
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:AbortMultipartUpload"
          ]
          resources = [
            "arn:aws:s3:::${var.environment}-${var.application_name}-example-artefact-bucket/*",
            "arn:aws:s3:::${var.environment}-${var.application_name}-example-output-bucket/*"
          ]
        },
        {
          sid    = "AllowSageMakerAccessTo${title(var.environment)}SageMakerExecutionRole"
          effect = "Allow"
          actions = [
            "sagemaker:DescribeModelPackage*",
            "sagemaker:ListModelPackageGroups",
            "sagemaker:ListModelPackages",
            "sagemaker:CreateModel",
            "sagemaker:CreatePipeline",
            "sagemaker:DescribePipeline",
            "sagemaker:CreateProcessingJob",
            "sagemaker:CreateTransformJob",
            "sagemaker:AddTags",
            "sagemaker:DescribeProcessingJob",
            "sagemaker:DescribeTransformJob",
            "sagemaker:DescribeModel",
            "sagemaker:ListPipelineExecutions",
            "sagemaker:ListPipelineExecutionSteps",
            "sagemaker:UpdatePipeline",
            "sagemaker:StopProcessingJob",
            "sagemaker:StopTransformJob"
          ]
          resources = [
            "arn:aws:sagemaker:${data.aws_region.current_region.name}:${data.aws_caller_identity.current_account.account_id}:*"
          ]
        },
        {
          sid    = "AllowCloudWatchAccessToSageMakerExecutionRole"
          effect = "Allow"
          actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          resources = [
            "arn:aws:logs:${data.aws_region.current_region.name}:${data.aws_caller_identity.current_account.account_id}:*"
          ]
        }
      ],
      assume_policy_principles : [{
        type        = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current_account.account_id}:role/github-actions-role"]
        },
        {
          type        = "Service"
          identifiers = ["sagemaker.amazonaws.com"]
          conditions : [{
            test     = "StringEquals"
            variable = "AWS:SourceAccount"
            values   = [data.aws_caller_identity.current_account.account_id]
          }]
        }
      ]
    }
  ]
}