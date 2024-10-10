module "terraform-submodules-sub1" {
  source = "./tf-sub-sub1"
}

module "terraform-submodules-sub2" {
  source = "./tf-sub-sub2"
}

module "terraform-submodules-sub3" {
  source = "./tf-sub-sub3"
}

resource "random_pet" "pet" {

}
