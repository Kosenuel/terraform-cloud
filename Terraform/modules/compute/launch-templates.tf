# Prepare Wordpress user data
# locals {
#   wordpress_userdata = templatefile("${path.module}/scripts/wordpress.sh", {
#     LOG_FILE="/var/log/wp-install.log"
#     TMP_MYSQL_CNF="/tmp/.mysql.cnf"
#     EFS_MOUNT="/var/www"
#     WORDPRESS_DIR = "/var/www/html/"
#     WP_CONFIG     ="/var/www/html/wp-config.php"
#     domain_name   = var.domain_name
#     EFS_ID        = var.efs_id
#     ACCESS_POINT  = var.wordpress_ap
#     RDS_ENDPOINT  = replace(var.rds_endpoint, ":3306", "")
#     DB_USER       = var.db_user
#     DB_PASSWORD   = var.db_password
#     RDS_USER      = var.rds_user
#     RDS_PASSWORD  = var.rds_password
#   })
# }

# Create Wordpress Launch Template
resource "aws_launch_template" "wordpress-launch-template" {
    name                    = "wordpress-launch-template"
    image_id                = var.ami-web
    instance_type           = var.instance_type
    vpc_security_group_ids  = [var.webserver-sg_id]
    key_name                = var.key_name

    iam_instance_profile {
        name = var.iam-instance-profile_name
    }

    placement {
        availability_zone = random_shuffle.az_list.result[0]
    }

    lifecycle {
        create_before_destroy = true
    }

    tag_specifications {
        resource_type = "instance"
        tags = merge(
            var.tags,
            {
                Name = "wordpress-launch-template"
            }
        )
    }

    # user_data = base64encode(local.wordpress_userdata)
}

# Prepare tooling userdata
# locals {
#     tooling_userdata = templatefile("${path.module}/scripts/tooling.sh",
#     {
#         domain_name  = var.domain_name
#         DB_HOST      = replace(var.rds_endpoint, ":3306", "")
#         DB_USER      = var.rds_user
#         DB_PASS      = var.rds_password
#         APP_DB_USER  = var.db_user
#         APP_DB_PASS  = var.db_password
#         EFS_ID       = var.efs_id
#         ACCESS_POINT = var.tooling_ap
#         LOG_FILE="/var/log/userdata.log"
#         TMP_MYSQL_CNF="/tmp/.mysqlcnf"
#         WEB_ROOT="/var/www/html"
#         EFS_MOUNT="/var/www"
#         REPO_URL="https://github.com/kosenuel/tooling.git"
#         APP_DB_NAME="toolingdb"

#     })
# }

# Create Tooling Launch Template
resource "aws_launch_template" "tooling-launch-template" {
    name                    = "tooling-launch-template"
    image_id                = var.ami-web
    instance_type           = var.instance_type
    vpc_security_group_ids  = [var.webserver-sg_id]
    key_name                = var.key_name

    iam_instance_profile {
        name = var.iam-instance-profile_name
    }

    placement {
        availability_zone = random_shuffle.az_list.result[0]
    }

    lifecycle {
        create_before_destroy = true
    }

    tag_specifications {
        resource_type = "instance"
        tags = merge(
            var.tags,
            {
                Name = "tooling-launch-template"
            }
        )
    }

    # user_data = base64encode(data.template_file.tooling_userdata.rendered)
    # user_data = base64encode(local.tooling_userdata)
}

# Prepare nginx userdata
# locals {
#     nginx_userdata = templatefile("${path.module}/scripts/nginx.sh", 
#     {
#         internal_alb_dns_name  = var.int-alb-dns_name
#     }
#     )
# }

# Create Nginx Launch Template
resource "aws_launch_template" "nginx-launch-template" {
    name                    = "nginx-launch-template"
    image_id                = var.ami-nginx
    instance_type           = var.instance_type
    vpc_security_group_ids  = [var.webserver-sg_id]
    key_name                = var.key_name

    iam_instance_profile {
        name = var.iam-instance-profile_name
    }

    placement {
        availability_zone = random_shuffle.az_list.result[0]
    }

    lifecycle {
        create_before_destroy = true
    }

    tag_specifications {
        resource_type = "instance"
        tags = merge(
            var.tags,
            {
                Name = "nginx-launch-template"
            }
        )   
    }

    # user_data = base64encode(local.nginx_userdata)
}