
variable "bucket" {
  type    = string
  default = "hl-web-tutorial"
}


variable "config" {
  type = map(object({
    bucket = string
    acl    = string
    web = object({
      index_document = string
      error_document = string
    })
  }))
  default = {
      sandbox = {
        acl    = "private"
        bucket = "hl-sandbox-tutorial"
        web = {
          error_document = "index.html"
          index_document = "error.html"
        }
      }

      qa = {
        acl    = "public-read"
        bucket = "hl-qa-tutorial"
        web = {
          error_document = "index.html"
          index_document = "error.html"
        }
      }
      stage = {
        acl    = "private"
        bucket = "hl-stage-tutorial"
        web = {
          error_document = "index.html"
          index_document = "error.html"
        }
      }
      prod = {
        acl    = "private"
        bucket = "hl-prod-tutorial"
        web = {
          error_document = "index.html"
          index_document = "error.html"
        }
      }
  }
}
