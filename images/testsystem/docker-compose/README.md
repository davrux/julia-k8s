# Overview

The docker-compose.yml will setup a complete Julia 3.6 test environment. It
consists of two julia systems in a cluster setup and a mail server with postfix
and dovecot. The mail server has the accounts alice and bob as internal and
external recipients.

# Julia 36 Testsystem

See docker-compose.yml for exposed ports. It receives emails on port 25
(mailoffice) and 26 (gateway) and delivers them finally to
julia_test_mail_server.

# Test Mail Server

Will accept mails for the following domains (see mailserver/Dockerfile):

    iccgmbh.com for alice
    internal.com for alice

    t-online.de for bob
    external.com for bob

Created accounts:

    alice pw test
    bob pw test


# SSH

SSH password for root is test12.

# Run

To run a Julia 3.6 with patchlevel 'feature3 use:

    make run PATCHLEVEL=feature3

# Cleanup

Use

    make down

to remove all docker containers.

The MongoDB images uses a volume, that Docker Compose does not remove.
Use

    docker volume prune
    
to remove unused volumes.
