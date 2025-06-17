.PHONY: build deploy clean

LAMBDA_SRC_DIR=lambda
LAMBDA_ZIP=terraform/lambda.zip

build:
	cd $(LAMBDA_SRC_DIR) && zip -r ../$(LAMBDA_ZIP) .

deploy: build
	cd terraform && terraform init
	cd terraform && terraform apply -auto-approve

clean:
	rm -f $(LAMBDA_ZIP)
