module "ec2" {
  source                = "./ec2"
  public_instance_type  = "t3.micro"
  private_instance_type = "t3.micro"
  edu_subnet_public_id  = module.networking.public_subnet_id
  edu_subnet_private_id = module.networking.private_subnet_id

}

module "networking" {
  source           = "./networking"
  aws_region       = "eu-central-1a" #Понял, что через aws_region указывается регион. Если без "а" то будет ругаться, мол надо указывать зону региона. С самого начала проекта видать некорректно задал имя переменной. Отсюда ноги растут. 
  vpc_cidr         = "10.0.0.0/16"
  vpc_cidr_private = "10.0.101.0/24"
  vpc_cidr_public  = "10.0.1.0/24"


}
