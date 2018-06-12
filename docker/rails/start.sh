#!/bin/bash
export SECRET_KEY_BASE=$(rake secret) && \
    #rake db:migrate && \
    rake assets:precompile --trace && \
    # the following symbolic links have to be created to bypass the asset pipeline
    # when including the specific assets of radon and radon-b
    # radon
    ln -s ../../app/assets/images/oxford_photo.jpg public/assets/oxford_photo.jpg && \
    ln -s ../../app/assets/images/c14_s.gif public/assets/c14_s.gif && \
    ln -s ../../app/assets/images/c14_s.png public/assets/c14_s.png && \
    # radon-b
    ln -s ../../app/assets/images/radon_b_image.png public/assets/radon_b_image.png && \
    ln -s ../../app/assets/images/radon_b_logo.png public/assets/radon_b_logo.png && \
    ln -s ../../app/assets/images/radon_b_schriftzug.png public/assets/radon_b_schriftzug.png && \
    # start webserver
    /opt/nginx/sbin/nginx

