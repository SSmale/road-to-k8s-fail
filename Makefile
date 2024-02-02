init:
	$(MAKE) -C terraform init

plan:
	$(MAKE) -C terraform plan

apply:
	$(MAKE) -C terraform apply