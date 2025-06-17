# lambda-project-1
# ----------------------------------------------------
# -------------- AWS Lambda ----------------
# --------------
Here’s how to deploy an AWS Lambda function using Terraform and set up a CI/CD pipeline with GitHub Actions for automatic deployment on every git push.
# --------------------------
Замени DNS на публичный (например, Google)
🔧 Временное решение (до перезагрузки)
bash
Copy code
sudo bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
✅ Теперь проверь:

bash
Copy code
nslookup registry.terraform.io
curl https://registry.terraform.io/.well-known/terraform.json

#-------------------------------------------------
