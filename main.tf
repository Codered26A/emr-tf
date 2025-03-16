provider "aws" {
  region = "us-east-1"
}

resource "aws_emr_cluster" "cluster" {
  name          = "emr-thbulls"
  release_label = "emr-7.0.0"
  applications  = ["Spark"]

  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true

  ec2_attributes {
    subnet_id                         = "subnet-04aac30ecf8834a37"
    emr_managed_master_security_group = "sg-02f2abd4e38011f79"
    emr_managed_slave_security_group  = "sg-09b525fdd11894cc4"
    instance_profile                  = "arn:aws:iam::975050324833:instance-profile/EMR_EC2_DefaultRole"
  }

  master_instance_group {
    instance_type = "m5.xlarge"
  }

  core_instance_group {
    instance_type  = "m5.xlarge"
    instance_count = 1

    ebs_config {
      size                 = "40"
      type                 = "gp2"
      volumes_per_instance = 1
    }

    # bid_price = "0.30"

  }

  ebs_root_volume_size = 100

  tags = {
    role       = "testing instance"
    env        = "dev"
    created_by = "kashyap"
  }

  #   bootstrap_action {
  #     path = "s3://elasticmapreduce/bootstrap-actions/run-if"
  #     name = "runif"
  #     args = ["instance.isMaster=true", "echo running on master node"]
  #   }

  service_role = "arn:aws:iam::975050324833:role/EMR_DefaultRole"
}