data "aws_ami" "centos" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_key_pair" "aws_key_pair_devops" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "aws_instance_openshift_minion1" {
  ami                    = "${data.aws_ami.centos.id}"
  instance_type          = "t2.medium"
  count                  = 1
  subnet_id              = "${var.aws_subnet_subnet_01_devops_id}"
  vpc_security_group_ids = ["${var.aws_security_group_aws_security_group_devops_id}"]

  root_block_device = {
    volume_size           = "50"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name   = "openshift-minion1"
    Server = "openshift-minion${count.index +1}"
    Group  = "DevOps"
  }

  key_name = "${aws_key_pair.aws_key_pair_devops.id}"

  provisioner "local-exec" {
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u centos --private-key ~/.ssh/id_rsa -i '${self.public_ip},' ./ansible/openshift_minion_main.yml;"
  }
}

resource "aws_route53_record" "ocminion1" {
  zone_id = "Z2QURGZ1E5ZGSS"
  name    = "ocminion1.blitznihar.com"
  type    = "A"
  ttl     = "300"

  records = [
    "${aws_instance.aws_instance_openshift_minion1.public_ip}",
  ]
}

resource "aws_instance" "aws_instance_openshift_minion2" {
  ami                    = "${data.aws_ami.centos.id}"
  instance_type          = "t2.medium"
  count                  = 1
  subnet_id              = "${var.aws_subnet_subnet_01_devops_id}"
  vpc_security_group_ids = ["${var.aws_security_group_aws_security_group_devops_id}"]

  root_block_device = {
    volume_size           = "50"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name   = "openshift-minion2"
    Server = "openshift-minion${count.index +1}"
    Group  = "DevOps"
  }

  key_name = "${aws_key_pair.aws_key_pair_devops.id}"

  provisioner "local-exec" {
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u centos --private-key ~/.ssh/id_rsa -i '${self.public_ip},' ./ansible/openshift_minion_main.yml;"
  }
}

resource "aws_route53_record" "ocminion2" {
  zone_id = "Z2QURGZ1E5ZGSS"
  name    = "ocminion2.blitznihar.com"
  type    = "A"
  ttl     = "300"

  records = [
    "${aws_instance.aws_instance_openshift_minion2.public_ip}",
  ]
}

resource "aws_instance" "aws_instance_openshift_master" {
  ami                    = "${data.aws_ami.centos.id}"
  instance_type          = "t2.xlarge"
  count                  = 1
  subnet_id              = "${var.aws_subnet_subnet_01_devops_id}"
  vpc_security_group_ids = ["${var.aws_security_group_aws_security_group_devops_id}"]

  root_block_device = {
    volume_size           = "50"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name   = "openshift_master"
    Server = "openshift_master${count.index +1}"
    Group  = "DevOps"
  }

  key_name = "${aws_key_pair.aws_key_pair_devops.id}"

  provisioner "local-exec" {
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u centos --private-key ~/.ssh/id_rsa -i '${aws_instance.aws_instance_openshift_master.public_ip},' ./ansible/openshift_master_main.yml"
  }
}

resource "aws_route53_record" "ocmaster" {
  zone_id = "Z2QURGZ1E5ZGSS"
  name    = "ocmaster.blitznihar.com"
  type    = "A"
  ttl     = "300"

  records = [
    "${aws_instance.aws_instance_openshift_master.public_ip}",
  ]
}
