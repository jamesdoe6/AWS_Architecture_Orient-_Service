.PHONY: aws.id
aws.id:
	@aws sts get-caller-identity

.PHONY: aws.instances
aws.instances:
	@aws ec2 describe-instances

.PHONY: aws.list-roles
aws.list-roles:
	@aws iam list-roles

.PHONY: aws.subnet
aws.subnet:
	@aws ec2 describe-subnets

.PHONY: whoami
whoami:
	aws sts get-caller-identity
