resource "null_resource" "sshkey_gen" {

  triggers = {
    uuid = uuid()
  }
  provisioner "local-exec" {
    command = "rm -rf out && mkdir -p -m 700 out && ssh-keygen -t rsa -f ./out/key -N hoge"
  }
}

resource "null_resource" "sshkey_cut" {
  triggers = {
    uuid = uuid()
  }
  provisioner "local-exec" {
    #command = "cat out/key.pub | cut -d ' ' -f 2 > out/key2.pub"
    command = "ssh-keygen -f out/key.pub -e -m pem"
  }
  depends_on = [
    null_resource.sshkey_gen,
  ]
}


locals {
  keypath = file("${path.module}/out/key2.pub")
}

resource "nifcloud_key_pair" "deployer" {
  count = fileexists(local.keypath) ? 1 : 0
  
  key_name    = "deployerkey"
  public_key  = local.keypath
  description = "memo"

  depends_on = [
    null_resource.sshkey_cut,
  ]
}