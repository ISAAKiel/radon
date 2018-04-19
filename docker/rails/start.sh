#!/bin/bash
export SECRET_KEY_BASE=$(rake secret) && \
    #rake db:migrate && \
    rake assets:precompile --trace && \
    /opt/nginx/sbin/nginx
