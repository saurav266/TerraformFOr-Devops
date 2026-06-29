//output "ec2_public_ip" {
   // value =aws_instance.my_instance.public_ip // single instance
  //  value =aws_instance.my_instance[*].public_ip // mutlilple
//}

//output "ec2_public_dns" {
   // value =aws_instance.my_instance.public_dns // for single output of instance 
    // value =aws_instance.my_instance[*].public_dns // multiple
//}

output "ec2_public_ip" {
    value= [
        for key in aws_instance.my_instance :key.public_ip
    ]
}

output "ec2_public_dns" {
    value =[
        for instance in aws_instance.my_instance : instance.public_dns
    ]
}