# Class:: tinytinyrss::params
#
#
class tinytinyrss::params {
  $tinytinyrss_path              = "/srv/tinytinyrss"
  $tinytinyrss_user              = "www-data"
  $tinytinyrss_title             = "Selfoss"
  $tinytinyrss_db_type           = "mysql"
  $tinytinyrss_db_file           = "data/sqlite/tinytinyrss.db"
  $tinytinyrss_db_host           = "localhost"
  $tinytinyrss_db_name           = "tinytinyrssdb"
  $tinytinyrss_db_user           = "tinytinyrssdbu"
  $tinytinyrss_db_password       = "changeme"
  $tinytinyrss_db_port           = 3306
  $tinytinyrss_db_prefix         = ""
} # Class:: tinytinyrss::params
