# GCS Fuse with Terraform
A template for creating a Compute Engine instance with a mounted Cloud Storage bucket

## How To Start the Project
- Step 1: Run the following commands to create the necessary VM and Bucket
```bash
terraform init
terraform plan
terraform apply
```  
- Step 2: Transfer credentials and mount the bucket using gcsfuse
``` 
scp ../credentials.json `terraform output vm-ip`:~
ssh `terraform output vm-ip`
sudo gcsfuse -o allow_other --gid 0 --uid 0 --file-mode 777 --dir-mode 777 --key-file /home/chris/credentials.json  gcs_storage_fuse /gcs_storage

```

## License

[MIT](https://choosealicense.com/licenses/mit/)
