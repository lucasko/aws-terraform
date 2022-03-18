
install_cli:
	curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
	installer -pkg AWSCLIV2.pkg -target /
	which aws
	aws --version

whoami:
	export AWS_PROFILE=my_admin
	aws sts get-caller-identity

users:
	aws iam list-users

ec2:
	aws ec2 run-instances