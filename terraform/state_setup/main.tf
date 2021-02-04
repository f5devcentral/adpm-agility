resource random_id id {
  byte_length = 2
}

data "template_file" "main_file" {
  template = file("../student_backend/main.tpl")
  vars = {
    student_id = random_id.id.hex
  }
}

resource "local_file" "main" {
  content  = data.template_file.main_file.rendered
  filename = "../student_backend/main.tf"
}

data "template_file" "backend_file" {
  template = file("../deploy/backend.tpl")
  vars = {
    student_id = random_id.id.hex
  }
}

resource "local_file" "backend" {
  content  = data.template_file.backend_file.rendered
  filename = "../deploy/backend.tf"
}

data "template_file" "studentid_file" {
  template = file("../f5module/studentid.tpl")
  vars = {
    student_id = random_id.id.hex
  }
}

resource "local_file" "studentid" {
  content  = data.template_file.studentid_file.rendered
  filename = "../f5module/studentid.tf"
}